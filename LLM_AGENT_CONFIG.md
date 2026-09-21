# LLM Agent Config Runbook

Manages Claude Code, Codex, OpenCode and Gemini from three sources of truth:

- `~/.config/mcphub/mcp_settings.json` — private upstream MCP processes, remote OAuth and bearer keys.
- `.rulesync/` — MCPHub client routes and normal lifecycle hooks.
- `.agent-permissions.jsonc` — permission policy.

`agentperm` connects the permission source to each tool and fills gaps Rulesync cannot express.
Rulesync owns MCP generation and normal hooks.

Verified against **rulesync 16.24.1** and **agentperm 0.4.0**.

> The tool was previously called `llm-agent-bridge`. It is now `agentperm`; the subcommands are
> the same, plus `init`, `validate`, `why` and `edit`.

## What Goes Where

### MCP Servers

MCPHub owns one long-lived upstream instance of each server. Its private runtime config is
`~/.config/mcphub/mcp_settings.json`; do not commit it because it contains credentials. The
`com.jackson.mcphub` LaunchAgent runs the globally installed `mcphub` executable and keeps it alive
on `http://127.0.0.1:3000`. `install.sh` updates MCPHub to the latest release; `setup.sh` renders the
LaunchAgent with local executable paths and optional corporate CA trust.

Put authenticated MCPHub routes such as `http://127.0.0.1:3000/mcp/<server>` in
`~/.rulesync/mcp.json`, then regenerate the global Claude and Codex clients:

```sh
rulesync generate --global --features mcp --targets claudecode,codexcli --input-roots "$HOME/.rulesync"
```

Use tool-specific `claudecode.mcpServers` and `codexcli.mcpServers` entries when a server should not
load in both clients. Project configs should contain only real project exceptions; otherwise they
inherit the global routes. Adding the same route globally and in a project is redundant even though
MCPHub still owns only one upstream process.

Dashboard login is `admin`. Retrieve its generated password from macOS Keychain without copying it
into dotfiles:

```sh
security find-generic-password -a "$USER" -s io.mcphub.admin-password -w
```

Authorize remote OAuth servers such as Notion once in the dashboard. MCPHub persists the refresh
token and refreshes access tokens; clients continue to use the local authenticated hub route.

#### `enabled` vs `disabled` — they are not the same

This is the one that bites. Rulesync has two independent fields:

| Field | Meaning | Reaches generated config? |
|-------|---------|---------------------------|
| `"enabled": false` | **Generation filter.** Keeps the definition in the source but emits it to *no* tool config at all. | No — rulesync-source-only |
| `"disabled": true` | **Pass-through.** Emits the server, marked off, in each tool's own spelling. | Yes |

`enabled: false` wins over `disabled`. Omitting `enabled` means enabled.

Use `"disabled": true` for the common case — a server you want *defined and toggleable* but not
loaded, so it doesn't consume context:

```json
{
  "mcpServers": {
    "miro": { "type": "http", "url": "https://mcp.miro.com", "disabled": true }
  }
}
```

Generates as:

| Tool | Output |
|------|--------|
| Claude Code | `"disabled": true` in `~/.claude.json` |
| Codex | `enabled = false` under `[mcp_servers.miro]` |
| OpenCode | `"enabled": false` |

> **Claude Code ignores it.** Verified: with `"disabled": true` written into `~/.claude.json`,
> `claude mcp list` still reports every one of those servers as `✔ Connected`. The pass-through
> field works for Codex and OpenCode only.

Toggling afterwards:

- **Claude Code** — `/mcp disable <server>`, which persists an **array of server names** under
  `"disabledMcpServers"` in the **project entry** of `~/.claude.json` (`projects["/path/to/repo"]`).
  It is *not* a flag on the server definition, and it is **per-project even for user-scope servers** —
  so there is no way to define a server globally and have it default to off. A fresh project starts
  with every user-scope server loaded. `claude mcp list` shows disabled ones as
  `⊘ Disabled for this project`.

  Global MCP for Claude lives in `~/.claude.json` (`mcpServers`); `.mcp.json` is project-scoped and
  uses a different pair of keys, `disabledMcpjsonServers` / `enabledMcpjsonServers` in
  `.claude/settings.local.json`. Don't confuse the two.

  Consequence: if a server must not cost context in Claude by default, the only reliable answer is
  **not to emit it to Claude at all** — scope it to a `codexcli` block instead of the shared map.
- **Codex** — no runtime toggle. `/mcp` only lists (`/mcp verbose` for detail) and `codex mcp`
  offers `list, get, add, remove, login, logout`. Flip it per-invocation instead:
  ```sh
  codex -c mcp_servers.miro.enabled=true -c mcp_servers.miro.required=true
  ```

#### Scoping a server to certain tools

Use a per-tool block:

```json
{
  "mcpServers": { "atlassian": { "type": "http", "url": "http://127.0.0.1:9001/mcp" } },
  "codexcli":   { "mcpServers": { "playwright": { "type": "stdio", "command": "npx",
                    "args": ["--yes", "@playwright/mcp@0.0.78", "--extension"] } } }
}
```

A tool-scoped entry **replaces a same-named shared entry wholesale** for that tool — which is also
how you re-enable, for one tool, a server the shared map disabled.

The older per-server `"targets": ["claudecode"]` array is still honoured as a filter, but it is
**deprecated and warns at generate time**. Migrate to `{toolname}.mcpServers` blocks.

### Normal Hooks

Put lifecycle and guard hooks in `.rulesync/hooks.json`, under the per-tool key (`claudecode`,
`codexcli`, `opencode`, `geminicli`) or the shared `hooks` map.

Rulesync uses **canonical** event names and translates them per tool. The one that catches people:
Claude Code's `UserPromptSubmit` is canonical **`beforeSubmitPrompt`**, not `userPromptSubmit`.

| Canonical | Claude Code |
|-----------|-------------|
| `sessionStart` / `sessionEnd` | `SessionStart` / `SessionEnd` |
| `preToolUse` / `postToolUse` | `PreToolUse` / `PostToolUse` |
| `beforeSubmitPrompt` | `UserPromptSubmit` |
| `stop` / `subagentStop` | `Stop` / `SubagentStop` |
| `permissionRequest` / `notification` | `PermissionRequest` / `Notification` |

Currently installed globally:

- `agentperm check` — permission policy (preToolUse, and permissionRequest for Codex)
- `agent-hook--pretool-python.py` — cross-agent banned-pattern guard for Python writes/edits
- `beckon` — terminal focus queue and tab marking:

  | Canonical event | Command |
  |-----------------|---------|
  | `stop`, `notification` | `beckon enqueue` |
  | `permissionRequest` | `beckon enqueue --permission` |
  | `postToolUse` | `beckon tool-done` |
  | `beforeSubmitPrompt`, `sessionEnd` | `beckon dequeue` |
  | `sessionStart` | `beckon refresh` |

Do not put permission policy in normal hooks unless it must call `agentperm`.

### Permissions

Put permission policy in `.agent-permissions.jsonc`. Examples: `Bash(ls:*)`, MCP tool allow/ask/deny
rules, structured shell rules such as prompting for `sed -i`.

Do **not** use `.rulesync/permissions.json` — it cannot express the shell behaviour we need.

`agentperm install` has two modes:

- `--mode rulesync` — writes its hooks into `~/.rulesync/hooks.json`, so **rulesync generate must run
  after it** to propagate them.
- `--mode direct` — writes per-tool configs, so it must run **after** rulesync generate or be overwritten.
- `--mode auto` (default) — detects rulesync.

`--dry-run` prints would-be writes.

## Gotchas

**`--base-dir` no longer exists.** Removed in current rulesync. Use `--global` for user scope, or
`cd` into the project (rulesync finds `./.rulesync/`). `--input-root` / `--output-roots` exist for
non-standard layouts.

**`--global` ignores `--output-roots` and writes straight to `$HOME`.** There is no way to redirect
it. To trial a change safely, either use `--dry-run`, or point `HOME` at a scratch directory:

```sh
FAKE=$(mktemp -d) && mkdir -p "$FAKE/.rulesync" && cp ~/.rulesync/*.json "$FAKE/.rulesync/"
HOME=$FAKE rulesync generate --global --features mcp --targets claudecode,codexcli
```

**Rulesync replaces the MCP block wholesale.** In `~/.codex/config.toml` it preserves `[features]`,
`[hooks.state.*]`, `[marketplaces.*]`, `[plugins.*]` and `[desktop]`, but rewrites `[mcp_servers.*]`
entirely. Any MCP server written by an app rather than by you — e.g. ChatGPT.app's `node_repl`,
which backs the `computer-use` plugin — is deleted on every `--features mcp` run unless it is also
in `.rulesync/mcp.json`.

Same for `~/.claude.json`: all other keys survive, `mcpServers` is replaced.

**Back up before regenerating.** `mcp.json` drifting behind the live configs is normal and silent.

```sh
B=~/.rulesync-backup-$(date +%Y%m%d-%H%M%S); mkdir -p "$B"
for f in .claude/settings.json .claude.json .codex/config.toml .config/opencode/opencode.jsonc; do
  mkdir -p "$B/$(dirname $f)" && cp "$HOME/$f" "$B/$f" 2>/dev/null
done
```

**`--dry-run` and `--check`** are available on `generate`; `--check` exits 1 if files are stale.

## Porting Existing Native Hooks And MCPs

`rulesync import` takes a **single** `--targets` tool, not a list.

```sh
cd ~                       # or ~/Code/<project>, dropping --global
cp -a ~/.rulesync ~/.rulesync.backup 2>/dev/null || true
rulesync import --global --features mcp,hooks --targets claudecode
rulesync generate --global --input-roots "$HOME/.rulesync" --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli
agentperm install
```

After importing, inspect `.rulesync/hooks.json` and `.rulesync/mcp.json`. Keep normal hooks and MCP
there; move permissions into `.agent-permissions.jsonc`.

## Setup Commands

### Global

```sh
rulesync generate --global --input-roots "$HOME/.rulesync" --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli
agentperm install
```

Sources: `~/.rulesync/mcp.json`, `~/.rulesync/hooks.json`, `~/.agent-permissions.jsonc`

Generated: `~/.claude/settings.json`, `~/.claude.json` (mcpServers only), `~/.codex/config.toml`
(mcp_servers only), `~/.codex/hooks.json`, `~/.config/opencode/opencode.jsonc`,
`~/.config/opencode/plugins/rulesync-hooks.js`, `~/.config/opencode/plugins/agent-bridge.js`,
`~/.gemini/policies/agent-bridge.toml`

Note: `geminicli` supports neither `mcp` nor `hooks` — rulesync skips it with a message.

### Per Project

Only for project MCP config. Never install permission hooks into project-local `.claude` or
`.codex` directories — those live in global rulesync only.

```sh
cd ~/Code/<project>
rulesync generate --features mcp --targets claudecode,codexcli,opencode,geminicli
```

Sources: `.rulesync/mcp.json`, `.rulesync/hooks.json` (project-specific normal hooks only),
`.agent-permissions.jsonc`

## Importing Native Whitelists

When an agent UI writes a whitelist into its own config after you approve a command:

```sh
agentperm import      # pulls native rules into ~/.agent-permissions.jsonc
agentperm install
```

Usually `agentperm install` alone is enough.

## Required Order

For `--mode direct`, rulesync first, then agentperm — rulesync owns generated MCP and normal hooks;
agentperm owns permission behaviour and patches the Codex `PermissionRequest` hook rulesync cannot
generate. If you run rulesync after agentperm, run agentperm again.

For `--mode rulesync` the order inverts: agentperm writes `~/.rulesync/hooks.json`, so rulesync
generate must run afterwards.

## Shell Permission Behavior

The bridge evaluates each segment of a compound command:

```sh
ls foo/bar | grep '\.py'
```

Allowed only when both `ls:*` and `grep:*` are allowed.

Redirection: `2>/dev/null` allowed for whitelisted commands; `> file`, `>> file`, `1> file`,
`&> file` prompt.

`sed`: `sed -n '1,10p' file` allowed if `sed:*` is; `sed -i`, `sed -i.bak`, `sed -Ei`,
`sed --in-place` prompt.

Unsupported shell syntax falls back to ask rather than auto-allowing.

## Smoke Tests

```sh
printf '%s' '{"cwd":"'"$PWD"'","tool_name":"Bash","tool_input":{"command":"ls foo/bar | grep '\''\\.py'\''"}}' \
  | agentperm check --agent claude --event PreToolUse

printf '%s' '{"cwd":"'"$PWD"'","tool_name":"Bash","tool_input":{"command":"ls 2>/dev/null"}}' \
  | agentperm check --agent claude --event PreToolUse

printf '%s' '{"cwd":"'"$PWD"'","tool_name":"Bash","tool_input":{"command":"ls > files.txt"}}' \
  | agentperm check --agent claude --event PreToolUse

printf '%s' '{"cwd":"'"$PWD"'","tool_name":"Bash","tool_input":{"command":"sed -Ei '\''s/a/b/'\'' file"}}' \
  | agentperm check --agent claude --event PreToolUse
```

Expected: pipe `allow`, `2>/dev/null` `allow`, `> files.txt` `ask`, `sed -Ei` `ask`.

`agentperm why '<command>'` explains what the merged policy decides.
`agentperm validate` checks policy files for unparseable rules and typo'd settings.

## Maintenance

After editing `.rulesync/mcp.json` or `.rulesync/hooks.json`:

```sh
rulesync generate --global --input-roots "$HOME/.rulesync" --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli
agentperm install
```

After editing `.agent-permissions.jsonc`, or approving a command inside an agent:

```sh
agentperm install
```

## Known Limitations

Codex:

- Rulesync does not generate Codex `PermissionRequest` hooks; `agentperm install` patches that in
  after generation.
- No runtime MCP enable/disable — use `codex -c mcp_servers.<name>.enabled=true`.
- App-written MCP servers in `config.toml` are wiped by `--features mcp` unless mirrored into
  `.rulesync/mcp.json`.

Gemini:

- Supports neither `mcp` nor `hooks` in rulesync; permissions are generated TOML, not runtime hook
  decisions. Re-run `agentperm install` after changing `.agent-permissions.jsonc`.
