#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dotfiles.conf"

# =============================================================================
# Helper Functions
# =============================================================================

# Shell-portable prompt helpers (prompt_yes / prompt_no / prompt_line).
source "${DOTFILES_PATH:-$HOME/.dotfiles}/lib.sh"

# Get the current login shell portably (Linux/WSL via getent, macOS via dscl,
# fallback to $SHELL).
current_login_shell() {
  if command -v getent >/dev/null 2>&1; then
    getent passwd "$USER" | cut -d: -f7
  elif command -v dscl >/dev/null 2>&1; then
    dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}'
  else
    echo "$SHELL"
  fi
}

# Check if symlink already points to correct target
# Returns 0 (true) if already correct, 1 (false) otherwise
is_correct_symlink() {
  local target="$1"
  local expected="$2"
  [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$expected" ]]
}

# Handle existing file/directory/symlink before creating symlink
# Returns 0 if we should proceed with symlink, 1 if we should skip
handle_existing() {
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -L "$target" ]]; then
      echo "  Symlink already exists: $target -> $(readlink "$target")"
    elif [[ -d "$target" ]]; then
      echo "  Directory already exists: $target"
    else
      echo "  File already exists: $target"
    fi
    if prompt_yes "  Delete it?"; then
      rm -rf "$target"
      return 0
    fi
    return 1
  fi
  return 0
}

# =============================================================================
# Home Directory Dotfiles
# =============================================================================

echo "=== Home Directory Dotfiles ==="
for dotfile in "${home_dotfiles[@]}"; do
  mkdir -p "$(dirname "$HOME/$dotfile")"
  if is_correct_symlink "$HOME/$dotfile" "$DOTFILES_PATH/$dotfile"; then
    echo "Already linked: ~/$dotfile"
    continue
  fi
  if ! handle_existing "$HOME/$dotfile"; then
    echo "  Skipped: ~/$dotfile"
    continue
  fi
  if prompt_yes "Symlink ~/$dotfile?"; then
    ln -s "$DOTFILES_PATH/$dotfile" "$HOME/$dotfile"
    echo "  Created: ~/$dotfile -> $DOTFILES_PATH/$dotfile"
  fi
done

# =============================================================================
# Config Directory Symlinks
# =============================================================================

echo ""
echo "=== Config Directory Symlinks ==="
mkdir -p ~/.config

for config_dir in "${config_dirs[@]}"; do
  if is_correct_symlink "$HOME/.config/$config_dir" "$DOTFILES_PATH/.config/$config_dir"; then
    echo "Already linked: ~/.config/$config_dir"
    continue
  fi
  if ! handle_existing "$HOME/.config/$config_dir"; then
    echo "  Skipped: ~/.config/$config_dir"
    continue
  fi
  if prompt_yes "Symlink ~/.config/$config_dir?"; then
    ln -s "$DOTFILES_PATH/.config/$config_dir" "$HOME/.config/$config_dir"
    echo "  Created: ~/.config/$config_dir -> $DOTFILES_PATH/.config/$config_dir"
  fi
done

# =============================================================================
# Special Setups
# =============================================================================

echo ""
echo "=== Special Setups ==="

# Agentperm's global policy includes a machine-local overlay for settings that
# should never be stored in the public dotfiles repository.
agentperm_local_policy="$HOME/.agent-permissions.local.jsonc"
if [[ ! -f "$agentperm_local_policy" ]]; then
  printf '%s\n' '{"version":1,"permissions":{"allow":[]}}' > "$agentperm_local_policy"
  chmod 600 "$agentperm_local_policy"
  echo "  Created private Agentperm overlay: $agentperm_local_policy"
fi

# Optional corporate CA. Copy it to a stable machine-local path, then generate
# npm and shell configuration from that path.
prompt_line "Corporate CA certificate path (Enter for none): " corporate_ca_source
corporate_ca="$HOME/.config/corporate-ca.pem"

if [[ -n "$corporate_ca_source" ]]; then
  if [[ ! -f "$corporate_ca_source" ]]; then
    echo "Corporate CA is not a file: $corporate_ca_source" >&2
    exit 1
  fi
  if [[ -f "$corporate_ca" ]] && cmp -s "$corporate_ca_source" "$corporate_ca"; then
    echo "  Corporate CA already copied: $corporate_ca"
  elif handle_existing "$corporate_ca"; then
    cp "$corporate_ca_source" "$corporate_ca"
    echo "  Copied corporate CA to $corporate_ca"
  else
    echo "  Keeping existing corporate CA: $corporate_ca"
  fi
  chmod 600 "$corporate_ca"
  touch "$HOME/.shrc.local"
  printf '\nexport NODE_EXTRA_CA_CERTS="%s"\nexport npm_config_cafile="%s"\n' \
    "$corporate_ca" "$corporate_ca" >> "$HOME/.shrc.local"
  export NODE_EXTRA_CA_CERTS="$corporate_ca"
  export npm_config_cafile="$corporate_ca"
else
  echo "  No corporate CA configured"
fi

if handle_existing "$HOME/.npmrc"; then
  cp "$DOTFILES_PATH/.npmrc" "$HOME/.npmrc"
  if [[ -n "$corporate_ca_source" ]]; then
    printf '\ncafile=%s\n' "$corporate_ca" >> "$HOME/.npmrc"
  fi
  chmod 600 "$HOME/.npmrc"
else
  echo "  Skipped: ~/.npmrc"
fi

# Rulesync, Agentperm, Beckon and MCPHub are installed by install.sh. Their
# source configuration is rendered here so secrets remain machine-local.
if prompt_yes "Configure AI tooling and LaunchAgents?"; then
  missing_ai_tools=()
  for command_name in jq openssl uuidgen plutil rulesync agentperm beckon mcphub node; do
    command -v "$command_name" >/dev/null 2>&1 || missing_ai_tools+=("$command_name")
  done

  if (( ${#missing_ai_tools[@]} )); then
    echo "  Skipped: run install.sh first (missing: ${missing_ai_tools[*]})"
  else
    mkdir -p "$HOME/.rulesync" "$HOME/.config/mcphub" "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"

    mcphub_settings="$HOME/.config/mcphub/mcp_settings.json"
    if [[ ! -f "$mcphub_settings" ]]; then
      jq --arg home "$HOME" \
        'walk(if type == "string" then gsub("__HOME__"; $home) else . end)' \
        "$DOTFILES_PATH/mcphub/mcp_settings.json.in" > "$mcphub_settings"
    fi

    mcphub_token="$(jq -r '[.bearerKeys[]? | select(.enabled == true and .name == "Local Rulesync clients")][0].token // empty' "$mcphub_settings")"
    if [[ -z "$mcphub_token" ]]; then
      mcphub_token="mcphub_$(openssl rand -hex 32)"
      mcphub_key_id="$(uuidgen | tr '[:upper:]' '[:lower:]')"
      jq --arg id "$mcphub_key_id" --arg token "$mcphub_token" \
        '.bearerKeys = ((.bearerKeys // []) + [{id: $id, name: "Local Rulesync clients", token: $token, enabled: true, kind: "system", accessType: "all", allowedGroups: [], allowedServers: []}])' \
        "$mcphub_settings" > "$mcphub_settings.tmp"
      mv "$mcphub_settings.tmp" "$mcphub_settings"
      echo "  Created private MCPHub bearer key"
    fi
    chmod 600 "$mcphub_settings"

    rulesync_hooks="$HOME/.rulesync/hooks.json"
    if handle_existing "$rulesync_hooks"; then
      jq --arg dotfiles "$DOTFILES_PATH" \
        'walk(if type == "string" then gsub("__DOTFILES_PATH__"; $dotfiles) else . end)' \
        "$DOTFILES_PATH/rulesync/hooks.json.in" > "$rulesync_hooks"
      chmod 600 "$rulesync_hooks"
    else
      echo "  Keeping existing Rulesync hooks"
    fi

    rulesync_mcp="$HOME/.rulesync/mcp.json"
    if handle_existing "$rulesync_mcp"; then
      jq --arg token "$mcphub_token" \
        'walk(if type == "string" then gsub("__MCPHUB_BEARER_TOKEN__"; $token) else . end)' \
        "$DOTFILES_PATH/rulesync/mcp.json.in" > "$rulesync_mcp"
      chmod 600 "$rulesync_mcp"
    else
      echo "  Keeping existing Rulesync MCP configuration"
    fi

    agentperm install --mode rulesync
    beckon hooks install claude
    beckon hooks install codex
    rulesync generate --global --input-roots "$HOME/.rulesync" \
      --features mcp,hooks --targets claudecode,codexcli,opencode
    beckon service install

    launch_agent="$HOME/Library/LaunchAgents/com.jackson.mcphub.plist"
    if handle_existing "$launch_agent"; then
      mcphub_path="$(command -v mcphub)"
      launch_path="$(dirname "$mcphub_path"):$(dirname "$(command -v node)"):$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
      jq --arg home "$HOME" --arg mcphub "$mcphub_path" --arg path "$launch_path" \
        --arg ca "$(test -n "$corporate_ca_source" && printf '%s' "$corporate_ca")" \
        'walk(if type == "string" then gsub("__HOME__"; $home) | gsub("__MCPHUB__"; $mcphub) | gsub("__PATH__"; $path) else . end)
         | if $ca == "" then . else .EnvironmentVariables.NODE_EXTRA_CA_CERTS = $ca end' \
        "$DOTFILES_PATH/Library/LaunchAgents/com.jackson.mcphub.plist.json" \
        | plutil -convert xml1 -o "$launch_agent" -
      chmod 600 "$launch_agent"
      plutil -lint "$launch_agent"
      launchctl bootout "gui/$UID/com.jackson.mcphub" >/dev/null 2>&1 || true
      launchctl bootstrap "gui/$UID" "$launch_agent"
      launchctl enable "gui/$UID/com.jackson.mcphub"
      echo "  MCPHub running at http://127.0.0.1:3000"
      echo "  MCP servers are disabled by default; enable and authenticate this machine's servers in the MCPHub dashboard"
    else
      echo "  Skipped MCPHub LaunchAgent"
    fi
  fi
fi

# Neovim config
if is_correct_symlink "$HOME/.config/nvim" "$DOTFILES_PATH/.vim"; then
  echo "Already linked: ~/.config/nvim"
elif ! handle_existing "$HOME/.config/nvim"; then
  echo "  Skipped: ~/.config/nvim"
elif prompt_yes "Setup Neovim config (~/.config/nvim -> ~/.dotfiles/.vim)?"; then
  ln -s "$DOTFILES_PATH/.vim" "$HOME/.config/nvim"
  echo "  Created: ~/.config/nvim -> $DOTFILES_PATH/.vim"
fi

# Personal git config
if prompt_yes "Setup personal git config (~/.gitconfig.local)?"; then
  if [[ -f "$HOME/.gitconfig.local" ]]; then
    echo "  File already exists: ~/.gitconfig.local"
    if prompt_yes "  Overwrite it?"; then
      cp "$DOTFILES_PATH/.gitconfig.personal" "$HOME/.gitconfig.local"
      echo "  Copied: ~/.gitconfig.local"
    else
      echo "  Skipped: ~/.gitconfig.local"
    fi
  else
    cp "$DOTFILES_PATH/.gitconfig.personal" "$HOME/.gitconfig.local"
    echo "  Copied: ~/.gitconfig.local"
  fi
fi

# Vim local config (before/after)
for suffix in before after; do
  local_file="$HOME/.vimrc.$suffix.local"
  example_file="$DOTFILES_PATH/.vimrc.$suffix.local.example"
  if [[ ! -f "$local_file" ]]; then
    if prompt_yes "Setup vim local config (~/.vimrc.$suffix.local from example)?"; then
      cp "$example_file" "$local_file"
      echo "  Copied: ~/.vimrc.$suffix.local"
    fi
  else
    echo "Skipping ~/.vimrc.$suffix.local (already exists)"
  fi
done

# Intelephense license (optional - for PHP development)
if prompt_no "Setup Intelephense license (PHP LSP)?"; then
  mkdir -p ~/intelephense
  prompt_line "Enter Intelephense license key: " intelephense_license
  echo
  if [[ -n "$intelephense_license" ]]; then
    echo "$intelephense_license" > ~/intelephense/license.txt
    echo "  Created: ~/intelephense/license.txt"
  else
    echo "  Skipped: No license key provided"
  fi
fi

# Sudoers timeout (optional - requires sudo)
if prompt_no "Setup sudoers timeout (extends sudo timeout to 60min, requires sudo)?"; then
  sudo cp "$DOTFILES_PATH/private/etc/sudoers.d/timeout" /private/etc/sudoers.d/timeout
  sudo chmod 440 /private/etc/sudoers.d/timeout
  sudo chown root:wheel /private/etc/sudoers.d/timeout
  echo "  Installed: /private/etc/sudoers.d/timeout"
fi

# Default login shell (portable: Linux, macOS, WSL)
zsh_path="$(command -v zsh)"
if [[ -z "$zsh_path" ]]; then
  echo "Skipping default shell (zsh not found on PATH)"
elif [[ "$(current_login_shell)" == "$zsh_path" ]]; then
  echo "Default shell already zsh ($zsh_path)"
elif prompt_yes "Set zsh ($zsh_path) as your default login shell?"; then
  if ! grep -qFx "$zsh_path" /etc/shells 2>/dev/null; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    echo "  Added to /etc/shells: $zsh_path"
  fi
  sudo chsh -s "$zsh_path" "$USER"
  echo "  Default shell set to $zsh_path (log out + back in to apply)"
fi

# Git aliases
if prompt_yes "Download GitAlias (extended git aliases)?"; then
  curl -fsSL https://raw.githubusercontent.com/GitAlias/gitalias/main/gitalias.txt -o "$DOTFILES_PATH/.gitalias"
  echo "  Downloaded: $DOTFILES_PATH/.gitalias"
fi

# =============================================================================
# Done
# =============================================================================

echo ""
echo "=== Setup Complete ==="
echo "You may need to restart your shell or run 'source ~/.zshrc' for changes to take effect."
