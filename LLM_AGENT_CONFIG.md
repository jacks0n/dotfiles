# LLM Agent Config Runbook

This setup manages Claude Code, Codex, OpenCode, and Gemini with two sources of truth:

- `.rulesync/` manages MCP servers and normal hooks.
- `.agent-permissions.jsonc` manages permissions.

`llm-agent-bridge` connects the permission source to each tool and fills gaps Rulesync cannot express.
Rulesync owns MCP generation; inspect generated MCP configs when using per-server `targets` until Rulesync filters them itself.

## What Goes Where

### MCP Servers

Put MCP servers in:

```text
.rulesync/mcp.json
```

Then regenerate tool configs:

```sh
rulesync generate --global --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli --base-dir "$HOME"
llm-agent-bridge install
```

To expose an MCP server only to selected tools, add `targets` to that server in `.rulesync/mcp.json`:

```json
{
  "mcpServers": {
    "codex": {
      "type": "stdio",
      "command": "codex",
      "args": ["mcp-server"],
      "env": {},
      "targets": ["claudecode"]
    }
  }
}
```

Rulesync currently accepts this metadata but does not filter MCP generation by it. Inspect generated MCP configs after Rulesync changes until Rulesync filters `targets` itself.

For global MCP:

```sh
rulesync generate --global --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli --base-dir "$HOME"
llm-agent-bridge install
```

### Normal Hooks

Put normal lifecycle and guard hooks in:

```text
.rulesync/hooks.json
```

Examples:

- `beckon enqueue`
- `beckon tool-done`
- GSD update checks
- project guards such as rejecting `type: ignore`

Rulesync syncs these hooks into supported tool configs. Tool-specific hook overrides can live under Rulesync's per-tool keys, such as `claudecode`, `codexcli`, `opencode`, and `geminicli`.

Do not put permission policy directly in normal hooks unless it must call `llm-agent-bridge`.

### Permissions

Put permission policy in:

```text
.agent-permissions.jsonc
```

Examples:

- `Bash(ls:*)`
- `Bash(grep:*)`
- MCP tool allow/ask/deny rules
- structured shell rules such as prompting for `sed -i`

Do not use:

```text
.rulesync/permissions.json
```

Rulesync permissions cannot express the shell behavior we need; keep permission policy in `.agent-permissions.jsonc`.

## Setup Commands

## Porting Existing Native Hooks And MCPs

If a project already has native Claude/Codex/OpenCode/Gemini hooks or MCP config that is not in `.rulesync/`, import those first:

```sh
cd ~/Code/<project>
cp -a .rulesync .rulesync.backup 2>/dev/null || true
rulesync import --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli
rulesync generate --features mcp --targets claudecode,codexcli,opencode,geminicli --base-dir "$PWD"
```

For global native hooks and MCP config:

```sh
cd ~
cp -a ~/.rulesync ~/.rulesync.backup 2>/dev/null || true
rulesync import --global --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli
rulesync generate --global --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli --base-dir "$HOME"
llm-agent-bridge install
```

After importing, inspect `.rulesync/hooks.json` and `.rulesync/mcp.json`. Keep normal hooks and MCP there; move any permissions into `.agent-permissions.jsonc`.

### Per Project

Run this inside each project only for project MCP config, for example `~/Code/personal`, `~/Code/privra`, `~/Code/quant-platform`, or `~/Code/coderift`.

Do not install bridge permission hooks in project-local `.claude` or `.codex` directories. Permission hooks live in global Rulesync and generated global agent config only.

```sh
cd ~/Code/<project>
rulesync generate --features mcp --targets claudecode,codexcli,opencode,geminicli --base-dir "$PWD"
```

Project source files:

- `.rulesync/mcp.json`
- `.rulesync/hooks.json` for project-specific normal hooks only, never bridge permission hooks
- `.agent-permissions.jsonc`

Generated project files may include:

- `.claude/settings.json`
- `.codex/config.toml`
- `.codex/hooks.json`
- `.opencode/plugins/rulesync-hooks.js`
- `.opencode/plugins/agent-bridge.js`
- `.gemini/policies/agent-bridge.toml`

### Global

Run this for global user config:

```sh
cd ~
rulesync generate --global --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli --base-dir "$HOME"
llm-agent-bridge install
```

Global source files:

- `~/.rulesync/mcp.json`
- `~/.rulesync/hooks.json`
- `~/.agent-permissions.jsonc`

Generated global files include:

- `~/.claude/settings.json`
- `~/.codex/config.toml`
- `~/.codex/hooks.json`
- `~/.config/opencode/plugins/rulesync-hooks.js`
- `~/.config/opencode/plugins/agent-bridge.js`
- `~/.gemini/policies/agent-bridge.toml`

## Importing Native Whitelists

Sometimes an agent UI writes a whitelist into its own native config after you approve a command.

To pull those native permissions back into `.agent-permissions.jsonc`:

```sh
cd ~/Code/<project>
llm-agent-bridge import
llm-agent-bridge install
```

For global:

```sh
cd ~
llm-agent-bridge import
llm-agent-bridge install
```

Usually this is enough:

```sh
llm-agent-bridge install
```

## Required Order

Always run Rulesync first, then the bridge:

```sh
rulesync generate --global --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli --base-dir "$HOME"
llm-agent-bridge install
```

Reason:

- Rulesync owns generated MCP config and normal hooks.
- The bridge owns permission behavior.
- Rulesync cannot currently generate Codex `PermissionRequest` hooks.
- Gemini permissions are compiled from `.agent-permissions.jsonc` into TOML.

If you run Rulesync after the bridge, run the bridge again.

## Shell Permission Behavior

The bridge supports compound commands by evaluating each segment:

```sh
ls foo/bar | grep '\.py'
```

This is allowed only when both `ls:*` and `grep:*` are allowed.

Redirection policy:

- `2>/dev/null`: allowed for whitelisted commands.
- `> file`, `>> file`, `1> file`, `&> file`: prompts.

`sed` policy:

- `sed -n '1,10p' file`: allowed if `sed:*` is allowed.
- `sed -i`, `sed -i.bak`, `sed -Ei`, `sed --in-place`: prompts.

Unsupported shell syntax falls back to ask/no-op rather than auto-allowing.

## Smoke Tests

Run these from a configured project:

```sh
printf '%s' '{"cwd":"'"$PWD"'","tool_name":"Bash","tool_input":{"command":"ls foo/bar | grep '\''\\.py'\''"}}' \
  | llm-agent-bridge check --agent claude --event PreToolUse

printf '%s' '{"cwd":"'"$PWD"'","tool_name":"Bash","tool_input":{"command":"ls 2>/dev/null"}}' \
  | llm-agent-bridge check --agent claude --event PreToolUse

printf '%s' '{"cwd":"'"$PWD"'","tool_name":"Bash","tool_input":{"command":"ls > files.txt"}}' \
  | llm-agent-bridge check --agent claude --event PreToolUse

printf '%s' '{"cwd":"'"$PWD"'","tool_name":"Bash","tool_input":{"command":"sed -Ei '\''s/a/b/'\'' file"}}' \
  | llm-agent-bridge check --agent claude --event PreToolUse
```

Expected decisions:

- pipe: `allow`
- `2>/dev/null`: `allow`
- `> files.txt`: `ask`
- `sed -Ei`: `ask`

## Maintenance

After editing `.rulesync/mcp.json` or `.rulesync/hooks.json`:

```sh
rulesync generate --global --features mcp,hooks --targets claudecode,codexcli,opencode,geminicli --base-dir "$HOME"
llm-agent-bridge install
```

After editing `.agent-permissions.jsonc`:

```sh
llm-agent-bridge install
```

After approving a command inside Claude Code, Codex, or OpenCode:

```sh
llm-agent-bridge install
```

For global config, use `--global --base-dir "$HOME"` with `rulesync generate`. `llm-agent-bridge install` writes global user config.

## Known Limitations

Codex:

- Rulesync does not currently support Codex `PermissionRequest` hooks.
- `llm-agent-bridge install` patches that Codex hook after Rulesync generation.
- Rulesync accepts MCP server `targets` metadata but does not currently filter MCP output with it.
- Inspect generated MCP configs after Rulesync generation when using `targets`.

Gemini:

- Gemini permissions are generated TOML, not runtime hook decisions.
- Re-run `llm-agent-bridge install` after changing `.agent-permissions.jsonc`.
