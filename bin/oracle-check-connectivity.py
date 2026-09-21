#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = ["oracledb>=2.5", "psutil>=6.0"]
# ///
"""Check an Oracle cluster endpoint, its listeners, and observed RAC redirects.

The configured endpoint is resolved to every advertised IP and each address is tested
independently. Authenticated probes also report the instance and server host selected by
Oracle and watch the client sockets for redirects (normally from a SCAN listener to a
node VIP). Repeated probes therefore exercise load balancing and expose intermittent
listener, VIP, routing, or database-login failures.

Run directly with ``uv`` available; inline metadata provisions python-oracledb.
Connection settings can be supplied as command-line options, environment variables, or an
optional dotenv file. A bare ``--password`` prompts without echo; an explicit password value
is also accepted but will be visible in shell history and the process list. Worker processes
receive credentials over stdin.
"""

from __future__ import annotations

import argparse
import csv
import getpass
import os
import re
import shlex
import socket
import statistics
import subprocess
import sys
import time
from collections import Counter
from collections.abc import Iterable, Sequence
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path

import oracledb
import psutil

_ATTEMPTS = 10
_TCP_TIMEOUT_SECONDS = 5.0
_ORACLE_TIMEOUT_SECONDS = 20.0
_MAX_CONCURRENT_ATTEMPTS = 4
_SESSION_CHECKS = 3
_SESSION_CHECK_INTERVAL_SECONDS = 0.5
_DEFAULT_PORT = 1521
_DEFAULT_ENV_PREFIX = "ORACLE"
_CONNECTION_ID = re.compile(r"\(CONNECTION_ID=[^)]+\)")
_SESSION_IDENTITY = re.compile(r"^instance=(\S+) host=(\S+) service=(\S+)$")
_WORKER_ARGUMENT = "--oracle-worker"
_WORKER_FIELD_COUNT = 8
_MAX_PORT = 65_535
_PROMPT_FOR_PASSWORD = object()


@dataclass(frozen=True, slots=True)
class Target:
    cluster: str
    target_type: str
    address: str
    port: int
    service: str
    username: str
    password: str


@dataclass(frozen=True, slots=True)
class TcpResult:
    status: str
    elapsed_ms: int
    peer_ip: str
    source_ip: str
    detail: str


@dataclass(frozen=True, slots=True)
class OracleResult:
    status: str
    elapsed_ms: int
    detail: str
    sockets: tuple[SocketObservation, ...]


@dataclass(frozen=True, slots=True)
class SocketObservation:
    source_address: str
    source_port: int
    address: str
    port: int
    states: tuple[str, ...]


@dataclass(frozen=True, slots=True)
class Result:
    target: Target
    attempt: int
    tcp: TcpResult
    oracle: OracleResult


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""examples:
  # ORACLE_HOSTNAME, ORACLE_SERVICE_NAME, ORACLE_USERNAME and ORACLE_PASSWORD
  %(prog)s --attempts 25

  # Existing variables such as FOO_HOSTNAME_UAT and FOO_PASSWORD_UAT
  %(prog)s --env-file ~/.env --env-prefix ORACLE --env-suffix UAT

  # Supplement DNS/redirect discovery with known cluster addresses
  %(prog)s --target NODE1=db-node-1.example --target VIP1=10.0.0.20:1521

  # Supply every connection setting as an option; --password prompts securely
  %(prog)s --host scan.example --port 1521 --service app.example --username app --password
""",
    )
    connection = parser.add_argument_group("connection")
    connection.add_argument(
        "--host",
        help="Cluster hostname, normally its SCAN name (or <PREFIX>_HOSTNAME / <PREFIX>_HOST)",
    )
    connection.add_argument(
        "--service",
        help="Oracle service name (or <PREFIX>_SERVICE_NAME / <PREFIX>_SERVICE)",
    )
    connection.add_argument(
        "--port",
        type=int,
        help=f"Listener port (or <PREFIX>_PORT; default: {_DEFAULT_PORT})",
    )
    connection.add_argument(
        "--username", help="Database username (or <PREFIX>_USERNAME)"
    )
    password_input = connection.add_mutually_exclusive_group()
    password_input.add_argument(
        "--password",
        nargs="?",
        const=_PROMPT_FOR_PASSWORD,
        metavar="PASSWORD",
        help="Database password; omit PASSWORD to prompt without echoing",
    )
    password_input.add_argument(
        "--password-stdin",
        action="store_true",
        help="Read the database password from one line on standard input",
    )
    connection.add_argument(
        "--env-prefix",
        default=_DEFAULT_ENV_PREFIX,
        help=f"Environment variable prefix (default: {_DEFAULT_ENV_PREFIX})",
    )
    connection.add_argument(
        "--env-suffix",
        default="",
        help="Optional suffix for variables such as FOO_HOSTNAME_UAT",
    )
    connection.add_argument(
        "--name",
        help="Label used in output (default: the configured host)",
    )
    connection.add_argument(
        "--target",
        action="append",
        metavar="LABEL=HOST[:PORT]",
        help="Also probe a known node, VIP, or listener; repeat as needed",
    )
    connection.add_argument(
        "--skip-resolved-targets",
        action="store_true",
        help="Do not add an independent target for every IP advertised by the main hostname",
    )
    parser.add_argument(
        "--attempts",
        type=int,
        default=_ATTEMPTS,
        help=f"Attempts per target: endpoint, each resolved IP, and explicit target (default: {_ATTEMPTS})",
    )
    parser.add_argument(
        "--tcp-timeout",
        type=float,
        default=_TCP_TIMEOUT_SECONDS,
        help=f"TCP connect timeout per attempt in seconds (default: {_TCP_TIMEOUT_SECONDS:g})",
    )
    parser.add_argument(
        "--oracle-timeout",
        type=float,
        default=_ORACLE_TIMEOUT_SECONDS,
        help=f"Hard Oracle login/query/redirect timeout per attempt in seconds (default: {_ORACLE_TIMEOUT_SECONDS:g})",
    )
    parser.add_argument(
        "--session-checks",
        type=int,
        default=_SESSION_CHECKS,
        help=f"Queries per established Oracle session, including the identity query (default: {_SESSION_CHECKS})",
    )
    parser.add_argument(
        "--session-check-interval",
        type=float,
        default=_SESSION_CHECK_INTERVAL_SECONDS,
        help=(
            "Seconds between post-login validation queries "
            f"(default: {_SESSION_CHECK_INTERVAL_SECONDS:g})"
        ),
    )
    parser.add_argument(
        "--skip-redirect-targets",
        action="store_true",
        help="Do not directly retest listener/VIP endpoints discovered through Oracle redirects",
    )
    parser.add_argument(
        "--jobs",
        type=int,
        default=_MAX_CONCURRENT_ATTEMPTS,
        help=f"Maximum simultaneous attempts (default: {_MAX_CONCURRENT_ATTEMPTS})",
    )
    parser.add_argument(
        "--tcp-only", action="store_true", help="Skip authenticated Oracle probes"
    )
    parser.add_argument(
        "--env-file",
        type=Path,
        help="Optional dotenv-style connection/credential file",
    )
    parser.add_argument(
        "--require-source",
        help="Abort unless every target routes through this source IP (for example, a VPN address)",
    )
    parser.add_argument(
        "--csv",
        type=Path,
        help="Also write every attempt to the given CSV path",
    )
    parser.add_argument(
        "--show-attempts",
        action="store_true",
        help="Print DNS/TCP and Oracle details for every attempt before the summary",
    )
    return parser


def _positive(value: float, name: str) -> None:
    if value <= 0:
        raise ValueError(f"{name} must be greater than zero")


def _read_env(path: Path | None) -> dict[str, str]:
    values = dict(os.environ)
    if path is None:
        return values
    selected = path.expanduser()
    if not selected.is_file():
        raise ValueError(f"Environment file does not exist: {selected}")
    for number, raw_line in enumerate(
        selected.read_text(encoding="utf-8").splitlines(), start=1
    ):
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("export "):
            line = line.removeprefix("export ").lstrip()
        if "=" not in line:
            raise ValueError(f"Invalid assignment at {selected}:{number}")
        name, raw_value = line.split("=", 1)
        tokens = shlex.split(raw_value, comments=True, posix=True)
        if len(tokens) > 1:
            raise ValueError(f"Invalid value at {selected}:{number}")
        values[name.strip()] = tokens[0] if tokens else ""
    return values


def _first_value(values: dict[str, str], names: Sequence[str]) -> str:
    value = next((values[name] for name in names if values.get(name)), "")
    if not value:
        raise ValueError(f"Missing required value: {' or '.join(names)}")
    return value


def _resolved_ips(host: str, port: int) -> list[str]:
    try:
        return sorted(
            {
                str(address[0])
                for _, _, _, _, address in socket.getaddrinfo(
                    host, port, type=socket.SOCK_STREAM
                )
            }
        )
    except socket.gaierror as error:
        raise ValueError(f"Cannot resolve {host}: {error}") from error


def _split_host_port(value: str, default_port: int) -> tuple[str, int]:
    if value.startswith("["):
        match = re.fullmatch(r"\[([^]]+)](?::(\d+))?", value)
        if not match:
            raise ValueError(f"Invalid target address: {value}")
        return match.group(1), int(match.group(2) or default_port)
    if value.count(":") == 1:
        host, raw_port = value.rsplit(":", 1)
        if raw_port.isdigit():
            return host, int(raw_port)
    return value, default_port


def _extra_target(raw_target: str, default_port: int) -> tuple[str, str, int]:
    label, separator, address = raw_target.partition("=")
    if not separator or not label.strip() or not address.strip():
        raise ValueError(f"Invalid --target {raw_target!r}; expected LABEL=HOST[:PORT]")
    host, port = _split_host_port(address.strip(), default_port)
    return label.strip().upper(), host, port


def _targets(
    cluster: str,
    host: str,
    port: int,
    service: str,
    username: str,
    password: str,
    extra_targets: Sequence[str],
    *,
    include_resolved: bool,
) -> list[Target]:
    addresses: list[tuple[str, str, int]] = [("ENDPOINT", host, port)]
    if include_resolved:
        addresses.extend(
            (f"RESOLVED-{index}", address, port)
            for index, address in enumerate(_resolved_ips(host, port), start=1)
            if address != host
        )
    addresses.extend(_extra_target(raw_target, port) for raw_target in extra_targets)
    unique: list[tuple[str, str, int]] = []
    seen: set[tuple[str, str, int]] = set()
    for item in addresses:
        if item not in seen:
            unique.append(item)
            seen.add(item)
    return [
        Target(cluster, target_type, address, target_port, service, username, password)
        for target_type, address, target_port in unique
    ]


def _route_source(destination: str, port: int) -> str:
    try:
        infos = socket.getaddrinfo(destination, port, type=socket.SOCK_DGRAM)
        family, socket_type, protocol, _, address = infos[0]
        with socket.socket(family, socket_type, protocol) as connection:
            connection.connect(address)
            return str(connection.getsockname()[0])
    except OSError as error:
        return f"unavailable:{error.errno or type(error).__name__}"


def _tcp_probe(target: Target, timeout: float) -> TcpResult:
    started = time.monotonic()
    try:
        with socket.create_connection(
            (target.address, target.port), timeout=timeout
        ) as connection:
            elapsed_ms = round((time.monotonic() - started) * 1_000)
            return TcpResult(
                "OK",
                elapsed_ms,
                str(connection.getpeername()[0]),
                str(connection.getsockname()[0]),
                "",
            )
    except TimeoutError:
        elapsed_ms = round((time.monotonic() - started) * 1_000)
        return TcpResult("TIMEOUT", elapsed_ms, "", "", f">={timeout:g}s")
    except socket.gaierror as error:
        elapsed_ms = round((time.monotonic() - started) * 1_000)
        return TcpResult(
            "ERROR", elapsed_ms, "", "", f"DNS error={error.errno or 'unknown'}"
        )
    except OSError as error:
        elapsed_ms = round((time.monotonic() - started) * 1_000)
        return TcpResult(
            "ERROR", elapsed_ms, "", "", f"errno={error.errno or 'unknown'}"
        )


def _worker_payload(
    target: Target,
    tcp_timeout: float,
    session_checks: int,
    session_check_interval: float,
) -> bytes:
    fields = (
        target.username,
        target.password,
        target.address,
        str(target.port),
        target.service,
        str(tcp_timeout),
        str(session_checks),
        str(session_check_interval),
    )
    return b"\0".join(field.encode() for field in fields)


def _oracle_probe(
    target: Target,
    tcp_timeout: float,
    oracle_timeout: float,
    session_checks: int,
    session_check_interval: float,
) -> OracleResult:
    started = time.monotonic()
    process = subprocess.Popen(
        (sys.executable, str(Path(__file__).resolve()), _WORKER_ARGUMENT),
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    assert process.stdin is not None
    process.stdin.write(
        _worker_payload(target, tcp_timeout, session_checks, session_check_interval)
    )
    process.stdin.close()
    process.stdin = None
    observed: dict[tuple[str, int, str, int], set[str]] = {}
    deadline = started + oracle_timeout
    timed_out = False
    try:
        monitored = psutil.Process(process.pid)
        while process.poll() is None and time.monotonic() < deadline:
            try:
                connections = monitored.net_connections(kind="tcp")
            except (psutil.AccessDenied, psutil.NoSuchProcess):
                connections = ()
            for connection in connections:
                if not connection.raddr:
                    continue
                source_address = str(connection.laddr.ip) if connection.laddr else "?"
                source_port = int(connection.laddr.port) if connection.laddr else 0
                endpoint = (
                    source_address,
                    source_port,
                    str(connection.raddr.ip),
                    int(connection.raddr.port),
                )
                observed.setdefault(endpoint, set()).add(connection.status or "UNKNOWN")
            time.sleep(0.01)
    finally:
        if process.poll() is None:
            timed_out = True
            process.kill()
    stdout, stderr = process.communicate()
    sockets = tuple(
        SocketObservation(
            source_address, source_port, address, port, tuple(sorted(states))
        )
        for (source_address, source_port, address, port), states in sorted(
            observed.items()
        )
    )
    if timed_out:
        elapsed_ms = round((time.monotonic() - started) * 1_000)
        return OracleResult("TIMEOUT", elapsed_ms, f">={oracle_timeout:g}s", sockets)
    elapsed_ms = round((time.monotonic() - started) * 1_000)
    output = stdout.decode(errors="replace").strip()
    status, _, detail = output.partition("\t")
    if status == "OK" and process.returncode == 0:
        return OracleResult("OK", elapsed_ms, detail, sockets)
    if status in {"ORACLE_ERROR", "DISCONNECTED"}:
        return OracleResult(status, elapsed_ms, detail, sockets)
    process_detail = (
        detail
        or stderr.decode(errors="replace").strip()
        or f"exit={process.returncode}"
    )
    return OracleResult("PROCESS_ERROR", elapsed_ms, process_detail, sockets)


def _probe(
    target: Target,
    attempt: int,
    tcp_timeout: float,
    oracle_timeout: float,
    session_checks: int,
    session_check_interval: float,
    *,
    tcp_only: bool,
) -> Result:
    tcp = _tcp_probe(target, tcp_timeout)
    if tcp_only or tcp.status != "OK":
        oracle = OracleResult(
            "SKIPPED",
            0,
            "TCP did not connect" if tcp.status != "OK" else "--tcp-only",
            (),
        )
    else:
        oracle = _oracle_probe(
            target,
            tcp_timeout,
            oracle_timeout,
            session_checks,
            session_check_interval,
        )
    return Result(target, attempt, tcp, oracle)


def _worker() -> int:
    fields = sys.stdin.buffer.read().split(b"\0")
    if len(fields) != _WORKER_FIELD_COUNT:
        print("PROCESS_ERROR\tinvalid worker input")
        return 2
    (
        username,
        password,
        address,
        raw_port,
        service,
        raw_tcp_timeout,
        raw_session_checks,
        raw_session_check_interval,
    ) = (field.decode() for field in fields)
    identity = ""
    try:
        with oracledb.connect(
            user=username,
            password=password,
            host=address,
            port=int(raw_port),
            service_name=service,
            tcp_connect_timeout=float(raw_tcp_timeout),
            retry_count=0,
        ) as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    """select sys_context('USERENV', 'INSTANCE_NAME'),
                              sys_context('USERENV', 'SERVER_HOST'),
                              sys_context('USERENV', 'SERVICE_NAME')
                         from dual"""
                )
                instance_name, server_host, service_name = cursor.fetchone()
                identity = f"instance={instance_name} host={server_host} service={service_name}"
                for _ in range(1, int(raw_session_checks)):
                    time.sleep(float(raw_session_check_interval))
                    cursor.execute("select 1 from dual")
                    cursor.fetchone()
            # Give the parent at least one sampling window even with one session check.
            time.sleep(0.1)
        print(f"OK\t{identity}")
        return 0
    except oracledb.Error as error:
        message = " | ".join(
            line.strip() for line in str(error).splitlines() if line.strip()
        )
        detail = _CONNECTION_ID.sub("(CONNECTION_ID=redacted)", message)
        status = "DISCONNECTED" if identity else "ORACLE_ERROR"
        prefix = f"{identity} | " if identity else ""
        print(f"{status}\t{prefix}{detail or type(error).__name__}")
        return 1


def _percentile(values: Sequence[int], percentile: float) -> int | None:
    if not values:
        return None
    ordered = sorted(values)
    return ordered[round((len(ordered) - 1) * percentile)]


def _latency(value: int | None) -> str:
    return "-" if value is None else str(value)


def _summary_row(target: Target, results: Sequence[Result]) -> list[str]:
    matching = [result for result in results if result.target == target]
    tcp_counts = Counter(result.tcp.status for result in matching)
    oracle_counts = Counter(result.oracle.status for result in matching)
    attempted_statuses = (
        "OK",
        "DISCONNECTED",
        "TIMEOUT",
        "ORACLE_ERROR",
        "PROCESS_ERROR",
    )
    oracle_attempted = sum(oracle_counts[status] for status in attempted_statuses)
    tcp_latencies = [
        result.tcp.elapsed_ms for result in matching if result.tcp.status == "OK"
    ]
    oracle_latencies = [
        result.oracle.elapsed_ms for result in matching if result.oracle.status == "OK"
    ]
    return [
        target.cluster,
        target.target_type,
        target.address,
        str(target.port),
        f"{tcp_counts['OK']}/{len(matching)}",
        str(tcp_counts["TIMEOUT"]),
        str(tcp_counts["ERROR"]),
        _latency(_percentile(tcp_latencies, 0.95)),
        f"{oracle_counts['OK']}/{oracle_attempted}" if oracle_attempted else "-",
        str(oracle_counts["DISCONNECTED"]),
        str(oracle_counts["TIMEOUT"]),
        str(oracle_counts["ORACLE_ERROR"]),
        str(oracle_counts["PROCESS_ERROR"]),
        _latency(
            round(statistics.median(oracle_latencies)) if oracle_latencies else None
        ),
        _latency(_percentile(oracle_latencies, 0.95)),
    ]


def _summary_rows(
    targets: Sequence[Target], results: Sequence[Result]
) -> list[list[str]]:
    return [_summary_row(target, results) for target in targets]


def _print_table(headers: Sequence[str], rows: Sequence[Sequence[str]]) -> None:
    widths = [
        max(len(header), *(len(row[index]) for row in rows))
        for index, header in enumerate(headers)
    ]
    separator = "+-" + "-+-".join("-" * width for width in widths) + "-+"

    def formatted(row: Sequence[str]) -> str:
        return (
            "| "
            + " | ".join(value.ljust(widths[index]) for index, value in enumerate(row))
            + " |"
        )

    print(separator)
    print(formatted(headers))
    print(separator)
    for row in rows:
        print(formatted(row))
    print(separator)


def _print_attempts(results: Sequence[Result]) -> None:
    print("\nAttempt details:")
    for result in results:
        tcp_route = ""
        if result.tcp.source_ip or result.tcp.peer_ip:
            tcp_route = f" source={result.tcp.source_ip or '-'} peer={result.tcp.peer_ip or '-'}"
        tcp_detail = f" detail={result.tcp.detail}" if result.tcp.detail else ""
        oracle_detail = (
            f" detail={result.oracle.detail}" if result.oracle.detail else ""
        )
        oracle_sockets = ", ".join(
            f"{observation.source_address}:{observation.source_port}"
            f"->{observation.address}:{observation.port}[{'/'.join(observation.states)}]"
            for observation in result.oracle.sockets
        )
        print(
            f"{result.target.cluster} {result.target.target_type} "
            f"{result.target.address}:{result.target.port}/{result.target.service} attempt={result.attempt}"
        )
        print(
            f"  TCP    {result.tcp.status} {result.tcp.elapsed_ms}ms{tcp_route}{tcp_detail}"
        )
        print(
            f"  ORACLE {result.oracle.status} {result.oracle.elapsed_ms}ms{oracle_detail}"
        )
        if oracle_sockets:
            print(f"  SOCKET {oracle_sockets}")


def _input_peer_ips(target: Target) -> set[str]:
    try:
        return {
            str(address[0])
            for _, _, _, _, address in socket.getaddrinfo(
                target.address, target.port, type=socket.SOCK_STREAM
            )
        }
    except socket.gaierror:
        return set()


def _socket_summary_rows(
    targets: Sequence[Target], results: Sequence[Result]
) -> list[list[str]]:
    rows: list[list[str]] = []
    for target in targets:
        primary_ips = _input_peer_ips(target)
        matching = [result for result in results if result.target == target]
        paths = sorted(
            {
                (item.source_address, item.address, item.port)
                for result in matching
                for item in result.oracle.sockets
            },
            key=lambda path: (path[0], path[2], path[1]),
        )
        for source_address, address, port in paths:
            observations = [
                (result, item)
                for result in matching
                for item in result.oracle.sockets
                if (item.source_address, item.address, item.port)
                == (source_address, address, port)
            ]
            role = (
                "INPUT"
                if port == target.port and address in primary_ips
                else "REDIRECT"
            )
            established = sum("ESTABLISHED" in item.states for _, item in observations)
            syn_only = sum(
                "SYN_SENT" in item.states and "ESTABLISHED" not in item.states
                for _, item in observations
            )
            attempt_ok = sum(result.oracle.status == "OK" for result, _ in observations)
            attempt_dropped = sum(
                result.oracle.status == "DISCONNECTED" for result, _ in observations
            )
            attempt_fail = sum(
                result.oracle.status not in {"OK", "SKIPPED", "DISCONNECTED"}
                for result, _ in observations
            )
            states = sorted(
                {state for _, item in observations for state in item.states}
            )
            rows.append(
                [
                    target.cluster,
                    target.target_type,
                    f"{target.address}:{target.port}",
                    source_address,
                    f"{address}:{port}",
                    role,
                    str(len(observations)),
                    str(established),
                    str(syn_only),
                    str(attempt_ok),
                    str(attempt_dropped),
                    str(attempt_fail),
                    ",".join(states),
                ]
            )
    return rows


def _session_summary_rows(
    targets: Sequence[Target], results: Sequence[Result]
) -> list[list[str]]:
    rows: list[list[str]] = []
    for target in targets:
        identities = Counter(
            result.oracle.detail
            for result in results
            if result.target == target and result.oracle.status == "OK"
        )
        for detail, count in sorted(identities.items()):
            match = _SESSION_IDENTITY.fullmatch(detail)
            instance, server_host, service = (
                match.groups() if match else (detail, "?", "?")
            )
            rows.append(
                [
                    target.cluster,
                    target.target_type,
                    f"{target.address}:{target.port}",
                    instance,
                    server_host,
                    service,
                    str(count),
                ]
            )
    return rows


def _discovered_redirect_targets(
    targets: Sequence[Target], results: Sequence[Result]
) -> list[Target]:
    if not targets:
        return []
    direct_endpoints = {
        (address, target.port)
        for target in targets
        for address in _input_peer_ips(target)
    }
    redirects = sorted(
        {
            (socket_observation.address, socket_observation.port)
            for result in results
            for socket_observation in result.oracle.sockets
            if (socket_observation.address, socket_observation.port)
            not in direct_endpoints
        },
        key=lambda endpoint: (endpoint[1], endpoint[0]),
    )
    template = targets[0]
    return [
        Target(
            template.cluster,
            f"REDIRECT-{index}",
            address,
            port,
            template.service,
            template.username,
            template.password,
        )
        for index, (address, port) in enumerate(redirects, start=1)
    ]


def _print_verdict(results: Sequence[Result]) -> None:
    tcp_failures = [result for result in results if result.tcp.status != "OK"]
    disconnects = [
        result for result in results if result.oracle.status == "DISCONNECTED"
    ]
    oracle_failures = [
        result
        for result in results
        if result.oracle.status not in {"OK", "SKIPPED", "DISCONNECTED"}
    ]
    if not tcp_failures and not disconnects and not oracle_failures:
        oracle_checks = sum(result.oracle.status == "OK" for result in results)
        print(
            f"\nRESULT: PASS — {len(results)}/{len(results)} direct TCP probes passed; "
            f"{oracle_checks} Oracle sessions completed without disconnecting."
        )
        return

    print(
        f"\nRESULT: FAIL — tcp_failures={len(tcp_failures)} "
        f"oracle_connect_failures={len(oracle_failures)} "
        f"mid_session_disconnects={len(disconnects)}"
    )
    failures = Counter(
        (
            result.tcp.source_ip
            or _route_source(result.target.address, result.target.port),
            f"{result.target.address}:{result.target.port}",
            result.tcp.peer_ip or "?",
            result.tcp.status,
            result.oracle.status,
            result.tcp.detail or result.oracle.detail,
        )
        for result in (*tcp_failures, *oracle_failures, *disconnects)
    )
    for (source, requested, peer, tcp_status, oracle_status, detail), count in sorted(
        failures.items()
    ):
        suffix = f" detail={detail}" if detail else ""
        print(
            f"  {count}x {source} -> {requested} (peer={peer}) "
            f"tcp={tcp_status} oracle={oracle_status}{suffix}"
        )


def _write_csv(path: Path, results: Iterable[Result]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as output:
        writer = csv.writer(output)
        writer.writerow(
            (
                "cluster",
                "service",
                "target_type",
                "address",
                "port",
                "attempt",
                "tcp_status",
                "tcp_elapsed_ms",
                "tcp_peer_ip",
                "source_ip",
                "tcp_detail",
                "oracle_status",
                "oracle_elapsed_ms",
                "oracle_detail",
                "oracle_sockets",
            )
        )
        for result in results:
            writer.writerow(
                (
                    result.target.cluster,
                    result.target.service,
                    result.target.target_type,
                    result.target.address,
                    result.target.port,
                    result.attempt,
                    result.tcp.status,
                    result.tcp.elapsed_ms,
                    result.tcp.peer_ip,
                    result.tcp.source_ip,
                    result.tcp.detail,
                    result.oracle.status,
                    result.oracle.elapsed_ms,
                    result.oracle.detail,
                    ";".join(
                        f"{item.source_address}:{item.source_port}"
                        f"->{item.address}:{item.port}[{'/'.join(item.states)}]"
                        for item in result.oracle.sockets
                    ),
                )
            )


def _configured_targets(args: argparse.Namespace) -> list[Target]:
    _positive(args.attempts, "--attempts")
    _positive(args.tcp_timeout, "--tcp-timeout")
    _positive(args.oracle_timeout, "--oracle-timeout")
    _positive(args.session_checks, "--session-checks")
    if args.session_check_interval < 0:
        raise ValueError("--session-check-interval must be zero or greater")
    _positive(args.jobs, "--jobs")
    values = _read_env(args.env_file)
    prefix = args.env_prefix.strip().upper()
    suffix = args.env_suffix.strip().upper()
    if not re.fullmatch(r"[A-Z][A-Z0-9_]*", prefix):
        raise ValueError(
            "--env-prefix must contain only letters, numbers, and underscores"
        )
    if suffix and not re.fullmatch(r"[A-Z0-9_]+", suffix):
        raise ValueError(
            "--env-suffix must contain only letters, numbers, and underscores"
        )

    def variable(key: str) -> str:
        return f"{prefix}_{key}" + (f"_{suffix}" if suffix else "")

    host = args.host or _first_value(values, (variable("HOSTNAME"), variable("HOST")))
    raw_port = (
        str(args.port)
        if args.port is not None
        else values.get(variable("PORT"), str(_DEFAULT_PORT))
    )
    try:
        port = int(raw_port)
    except ValueError as error:
        raise ValueError(f"Invalid Oracle listener port: {raw_port!r}") from error
    if not 0 < port <= _MAX_PORT:
        raise ValueError("--port must be between 1 and 65535")

    service = (
        args.service
        or values.get(variable("SERVICE_NAME"))
        or values.get(variable("SERVICE"), "")
    )
    username = args.username or values.get(variable("USERNAME"), "")
    if args.password is _PROMPT_FOR_PASSWORD:
        password = getpass.getpass("Oracle password: ")
    elif args.password is not None:
        password = args.password
    elif args.password_stdin:
        password = sys.stdin.readline().rstrip("\r\n")
    else:
        password = values.get(variable("PASSWORD"), "")
    if not args.tcp_only:
        if not service:
            raise ValueError(
                f"Missing required value: --service or {variable('SERVICE_NAME')}"
            )
        if not username:
            raise ValueError(
                f"Missing required value: --username or {variable('USERNAME')}"
            )
        if not password:
            raise ValueError(
                f"Missing required value: --password, --password-stdin, or {variable('PASSWORD')}"
            )
    return _targets(
        args.name or host,
        host,
        port,
        service,
        username,
        password,
        tuple(args.target or ()),
        include_resolved=not args.skip_resolved_targets,
    )


def _validate_route(
    args: argparse.Namespace, targets: Sequence[Target]
) -> list[str] | None:
    route_sources = sorted(
        {_route_source(target.address, target.port) for target in targets}
    )
    routed_ips = {
        source for source in route_sources if not source.startswith("unavailable:")
    }
    if args.require_source and routed_ips != {args.require_source}:
        print(
            f"error: routed source is {','.join(route_sources)}, expected {args.require_source}; "
            "check VPN/network attachment",
            file=sys.stderr,
        )
        return None
    return route_sources


def _run_probes(args: argparse.Namespace, targets: Sequence[Target]) -> list[Result]:
    total = len(targets) * args.attempts
    work = (
        (target, attempt)
        for attempt in range(1, args.attempts + 1)
        for target in targets
    )
    results: list[Result] = []
    with ThreadPoolExecutor(max_workers=args.jobs) as executor:
        futures = [
            executor.submit(
                _probe,
                target,
                attempt,
                args.tcp_timeout,
                args.oracle_timeout,
                args.session_checks,
                args.session_check_interval,
                tcp_only=args.tcp_only,
            )
            for target, attempt in work
        ]
        for completed, future in enumerate(as_completed(futures), start=1):
            results.append(future.result())
            if completed % 50 == 0 or completed == total:
                print(f"Completed {completed}/{total}", file=sys.stderr, flush=True)
    return sorted(
        results,
        key=lambda result: (
            result.target.cluster,
            result.target.port,
            result.target.address,
            result.attempt,
        ),
    )


def _print_summary(
    args: argparse.Namespace, targets: Sequence[Target], results: Sequence[Result]
) -> None:
    if args.show_attempts:
        _print_attempts(results)
    headers = (
        "CLUSTER",
        "TARGET",
        "ADDRESS",
        "PORT",
        "TCP OK",
        "TCP TO",
        "TCP ERR",
        "TCP P95",
        "ORA OK",
        "ORA DROP",
        "ORA TO",
        "ORA ERR",
        "ORA OTHER",
        "ORA P50",
        "ORA P95",
    )
    print(
        "\nLatency columns are milliseconds; ORA timing includes login, RAC redirect, "
        f"identity retrieval, and {args.session_checks} session checks."
    )
    _print_table(headers, _summary_rows(targets, results))
    session_rows = _session_summary_rows(targets, results)
    if session_rows:
        print(
            "\nDatabase destinations selected by Oracle. Multiple instances/hosts show how repeated "
            "connections were distributed by the cluster."
        )
        _print_table(
            (
                "CLUSTER",
                "TARGET",
                "REQUESTED",
                "INSTANCE",
                "DB HOST",
                "SERVICE",
                "COUNT",
            ),
            session_rows,
        )
    socket_rows = _socket_summary_rows(targets, results)
    if socket_rows:
        print(
            "\nObserved Oracle TCP endpoints. REDIRECT means the endpoint differed from the requested "
            "host's resolved IPs and port. SYN ONLY means the sampler did not observe ESTABLISHED; "
            "use the whole attempt outcome to determine success. "
            "ATTEMPT outcome is for the whole Oracle attempt, which may have tried multiple endpoints."
        )
        _print_table(
            (
                "CLUSTER",
                "TARGET",
                "REQUESTED",
                "SOURCE",
                "OBSERVED",
                "ROLE",
                "SEEN",
                "EST",
                "SYN ONLY",
                "ATTEMPT OK",
                "DROPPED",
                "ATTEMPT FAIL",
                "STATES",
            ),
            socket_rows,
        )
    elif not args.tcp_only:
        print(
            "\nNo Oracle worker TCP sockets were captured; see CSV/attempt errors and process permissions."
        )
    if args.csv:
        output_path = args.csv.expanduser()
        _write_csv(output_path, results)
        print(f"Raw results: {output_path}")
    _print_verdict(results)


def main(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    try:
        targets = _configured_targets(args)
    except (OSError, ValueError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 2

    route_sources = _validate_route(args, targets)
    if route_sources is None:
        return 2

    total = len(targets) * args.attempts
    print(
        f"Oracle cluster connectivity: runner={socket.gethostname()} routed_source={','.join(route_sources)} "
        f"permutations={len(targets)} attempts={args.attempts} total={total} "
        f"tcp_timeout={args.tcp_timeout:g}s oracle_timeout={args.oracle_timeout:g}s "
        f"session_checks={args.session_checks} session_interval={args.session_check_interval:g}s "
        f"jobs={args.jobs}",
        flush=True,
    )

    results = _run_probes(args, targets)
    if not args.tcp_only and not args.skip_redirect_targets:
        redirect_targets = _discovered_redirect_targets(targets, results)
        if redirect_targets:
            endpoints = ", ".join(
                f"{target.address}:{target.port}" for target in redirect_targets
            )
            print(
                f"Directly testing {len(redirect_targets)} discovered redirect endpoint(s): {endpoints}",
                file=sys.stderr,
                flush=True,
            )
            if _validate_route(args, redirect_targets) is None:
                return 2
            targets = [*targets, *redirect_targets]
            results = sorted(
                [*results, *_run_probes(args, redirect_targets)],
                key=lambda result: (
                    result.target.cluster,
                    result.target.port,
                    result.target.address,
                    result.attempt,
                ),
            )
    _print_summary(args, targets, results)

    tcp_failures = sum(result.tcp.status != "OK" for result in results)
    oracle_failures = sum(
        result.oracle.status not in {"OK", "SKIPPED"} for result in results
    )
    if tcp_failures or oracle_failures:
        print(f"Failures: tcp={tcp_failures}, oracle={oracle_failures}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(_worker() if sys.argv[1:] == [_WORKER_ARGUMENT] else main())
