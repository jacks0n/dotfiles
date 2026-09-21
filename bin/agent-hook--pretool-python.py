#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = ["tree-sitter", "tree-sitter-python"]
# ///
"""Cross-agent pre-tool hook for banned Python patterns.

Accepts Claude Code, Codex, Gemini CLI, and Kiro CLI hook payloads on stdin.
Only proposed content for ``.py`` files is parsed with tree-sitter.
"""
from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass
from typing import TYPE_CHECKING, Literal, NamedTuple

import tree_sitter_python as tspython
from tree_sitter import Language, Parser

if TYPE_CHECKING:
    from tree_sitter import Node

# ── Rules ────────────────────────────────────────────────────────────────
# Each key maps a pattern/name to its rejection message.

BANNED_COMMENT_PATTERNS: dict[str, tuple[str, str]] = {
    "noqa": ("noqa", "noqa suppression — fix the lint issue"),
    "type: ignore": ("type-ignore", "type: ignore — fix the type error"),
    "type:ignore": ("type-ignore", "type: ignore — fix the type error"),
    "pyright: ignore": ("pyright-ignore", "pyright: ignore — fix the type error"),
    "pyright:ignore": ("pyright-ignore", "pyright: ignore — fix the type error"),
}

BANNED_TYPE_IDENTIFIERS: dict[str, tuple[str, str]] = {
    "Any": ("any", "Any is not a type — model the domain precisely"),
}

BANNED_CALLS: dict[str, tuple[str, str]] = {
    "cast": ("cast", "cast() hides a type error — model or narrow the type precisely"),
}

# ── AST helpers ──────────────────────────────────────────────────────────

_PARSER = Parser(Language(tspython.language()))


def _is_inside(node: Node, ancestor_type: str) -> bool:
    cur = node.parent
    while cur is not None:
        if cur.type == ancestor_type:
            return True
        cur = cur.parent
    return False


def find_violations(source: bytes, allowed: frozenset[str] = frozenset()) -> list[str]:
    tree = _PARSER.parse(source)
    violations: list[str] = []

    def walk(node: Node) -> None:
        if node.type == "comment":
            text = node.text.decode() if node.text else ""
            for pattern, (rule, msg) in BANNED_COMMENT_PATTERNS.items():
                if pattern in text and rule not in allowed:
                    violations.append(f"L{node.start_point[0] + 1}: {msg}")
                    break

        elif node.type == "identifier" and node.text is not None:
            name = node.text.decode()
            banned_type = BANNED_TYPE_IDENTIFIERS.get(name)
            if (
                banned_type is not None
                and banned_type[0] not in allowed
                and not _is_inside(node, "string")
            ):
                violations.append(
                    f"L{node.start_point[0] + 1}: {banned_type[1]}"
                )

        elif node.type == "call":
            function = node.child_by_field_name("function")
            called_name: str | None = None
            if function is not None:
                if function.type == "identifier" and function.text:
                    called_name = function.text.decode()
                elif function.type == "attribute":
                    attribute = function.child_by_field_name("attribute")
                    if attribute is not None and attribute.text:
                        called_name = attribute.text.decode()
            if called_name is not None:
                banned_call = BANNED_CALLS.get(called_name)
                if banned_call is not None and banned_call[0] not in allowed:
                    violations.append(
                        f"L{node.start_point[0] + 1}: {banned_call[1]}"
                    )

        for child in node.children:
            walk(child)

    walk(tree.root_node)
    return violations


# ── Codex apply_patch envelope ──────────────────────────────────────────
# Codex's apply_patch tool sends {"command": "*** Begin Patch\n*** Update
# File: foo.py\n...*** End Patch"} instead of Claude Code's {file_path,
# content/new_string}. Parse it into the same hunk/chunk shape as the
# reference grammar (codex-rs/apply-patch/src/parser.rs) rather than
# scanning lines for "+" prefixes, so file boundaries and removed/context
# lines are handled the way Codex itself parses them:
#
#   start: begin_patch environment_id? hunk+ end_patch
#   hunk: add_hunk | delete_hunk | update_hunk
#   add_hunk: "*** Add File: " filename LF add_line+
#   delete_hunk: "*** Delete File: " filename LF
#   update_hunk: "*** Update File: " filename LF change_move? change?
#   change: (change_context | change_line)+ eof_line?
#   change_context: ("@@" | "@@ " /(.+)/) LF
#   change_line: ("+" | "-" | " ") /(.+)/ LF

_HEREDOC_OPENERS = ("<<EOF", "<<'EOF'", '<<"EOF"')


@dataclass
class AddFile:
    path: str
    contents: str


@dataclass
class DeleteFile:
    path: str


@dataclass
class UpdateChunk:
    added_lines: list[str]


@dataclass
class UpdateFile:
    path: str
    move_path: str | None
    chunks: list[UpdateChunk]


Hunk = AddFile | DeleteFile | UpdateFile


def _unwrap_heredoc(lines: list[str]) -> list[str]:
    # gpt-4.1-style local_shell calls wrap the patch in a `<<'EOF' ... EOF` heredoc
    # instead of passing it as-is; Codex parses this leniently, so we do too.
    if len(lines) >= 4 and lines[0] in _HEREDOC_OPENERS and lines[-1].endswith("EOF"):
        return lines[1:-1]
    return lines


def _parse_patch(patch_text: str) -> list[Hunk]:
    lines = _unwrap_heredoc(patch_text.strip().splitlines())
    if not lines or lines[0].strip() != "*** Begin Patch":
        return []

    hunks: list[Hunk] = []
    i = 1
    while i < len(lines):
        line = lines[i]
        if line == "*** End Patch" or line.startswith("*** Environment ID: "):
            i += 1
        elif line.startswith("*** Add File: "):
            path = line[len("*** Add File: ") :].strip()
            added: list[str] = []
            i += 1
            while i < len(lines) and lines[i].startswith("+"):
                added.append(lines[i][1:])
                i += 1
            hunks.append(AddFile(path=path, contents="\n".join(added)))
        elif line.startswith("*** Delete File: "):
            hunks.append(DeleteFile(path=line[len("*** Delete File: ") :].strip()))
            i += 1
        elif line.startswith("*** Update File: "):
            path = line[len("*** Update File: ") :].strip()
            i += 1
            move_path: str | None = None
            if i < len(lines) and lines[i].startswith("*** Move to: "):
                move_path = lines[i][len("*** Move to: ") :].strip()
                i += 1
            chunks: list[UpdateChunk] = []
            current: list[str] | None = None
            while i < len(lines) and not lines[i].startswith("*** "):
                change_line = lines[i]
                if change_line == "@@" or change_line.startswith("@@ "):
                    current = []
                    chunks.append(UpdateChunk(added_lines=current))
                elif change_line.startswith("+"):
                    if current is None:
                        current = []
                        chunks.append(UpdateChunk(added_lines=current))
                    current.append(change_line[1:])
                # Removed and context lines are not proposed content.
                i += 1
            hunks.append(UpdateFile(path=path, move_path=move_path, chunks=chunks))
        else:
            i += 1

    return hunks


def _python_texts(hunks: list[Hunk]) -> list[str]:
    texts: list[str] = []
    for hunk in hunks:
        if isinstance(hunk, AddFile) and hunk.path.endswith(".py"):
            texts.append(hunk.contents)
        elif isinstance(hunk, UpdateFile) and (hunk.move_path or hunk.path).endswith(".py"):
            texts.append(
                "\n".join(
                    line for chunk in hunk.chunks for line in chunk.added_lines
                )
            )
    return texts


# ── Provider adapters ───────────────────────────────────────────────────

Provider = Literal["auto", "claude", "codex", "gemini", "kiro"]


class Options(NamedTuple):
    provider: Provider
    allowed: frozenset[str]


def _provider_for(payload: dict[str, object], requested: Provider) -> Provider:
    if requested != "auto":
        return requested

    event = payload.get("hook_event_name")
    tool = payload.get("tool_name")
    if event == "BeforeTool":
        return "gemini"
    if event == "preToolUse":
        return "kiro"
    if tool == "apply_patch":
        return "codex"
    return "claude"


def _string(value: object) -> str | None:
    return value if isinstance(value, str) and value else None


def _path(tool_input: dict[str, object]) -> str | None:
    return _string(tool_input.get("file_path")) or _string(tool_input.get("path"))


def _direct_python_text(tool_input: dict[str, object]) -> list[str]:
    path = _path(tool_input)
    if path is None or not path.endswith(".py"):
        return []

    text = (
        _string(tool_input.get("content"))
        or _string(tool_input.get("new_string"))
        or _string(tool_input.get("newStr"))
    )
    return [text] if text is not None else []


def _claude_texts(tool_input: dict[str, object]) -> list[str]:
    edits = tool_input.get("edits")
    path = _path(tool_input)
    if isinstance(edits, list) and path is not None and path.endswith(".py"):
        return [
            text
            for edit in edits
            if isinstance(edit, dict)
            and (text := _string(edit.get("new_string"))) is not None
        ]
    return _direct_python_text(tool_input)


def _extract_python_texts(
    provider: Provider, tool_input: dict[str, object]
) -> list[str]:
    if provider == "codex":
        command = _string(tool_input.get("command"))
        return _python_texts(_parse_patch(command)) if command is not None else []
    if provider == "claude":
        return _claude_texts(tool_input)
    return _direct_python_text(tool_input)


def _deny(provider: Provider, detail: str) -> None:
    reason = f"BLOCKED — {detail}"
    if provider == "kiro":
        print(reason, file=sys.stderr)
        raise SystemExit(2)
    if provider == "gemini":
        json.dump({"decision": "deny", "reason": reason}, sys.stdout)
        return
    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": reason,
            }
        },
        sys.stdout,
    )


# ── Hook entry point ─────────────────────────────────────────────────────


def _parse_args() -> Options:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--provider",
        choices=("auto", "claude", "codex", "gemini", "kiro"),
        default="auto",
        help="hook wire format (default: infer from the payload)",
    )
    for rule in ("noqa", "type-ignore", "pyright-ignore", "any", "cast"):
        parser.add_argument(
            f"--allow-{rule}",
            action="store_true",
            help=f"allow the otherwise-blocked {rule} rule",
        )
    args = parser.parse_args()
    allowed = frozenset(
        rule
        for rule in ("noqa", "type-ignore", "pyright-ignore", "any", "cast")
        if getattr(args, f"allow_{rule.replace('-', '_')}")
    )
    return Options(provider=args.provider, allowed=allowed)


def main() -> None:
    options = _parse_args()
    hook_input = json.load(sys.stdin)
    if not isinstance(hook_input, dict):
        return
    tool_input = hook_input.get("tool_input")
    if not isinstance(tool_input, dict):
        return

    provider = _provider_for(hook_input, options.provider)
    texts = _extract_python_texts(provider, tool_input)

    violations = [
        v for text in texts for v in find_violations(text.encode(), options.allowed)
    ]
    if not violations:
        return

    _deny(provider, "; ".join(violations))


if __name__ == "__main__":
    main()
