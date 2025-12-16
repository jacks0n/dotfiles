#!/usr/bin/env bash

export DOTFILES_PATH="$HOME/.dotfiles"

# =============================================================================
# Helper Functions
# =============================================================================

# Prompt with default Y - returns 0 (true) if yes, 1 (false) if no
prompt_yes() {
  local message="$1"
  read -p "$message [Y/n]: " -n 1 -r
  echo
  [[ ! $REPLY =~ ^[Nn]$ ]]
}

# Prompt with default N - returns 0 (true) if yes, 1 (false) if no
prompt_no() {
  local message="$1"
  read -p "$message [y/N]: " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]]
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

home_dotfiles=(
  .aliases
  .bashrc
  .ctags
  .curlrc
  .editorconfig
  .exports
  .functions
  .gitconfig
  .hushlogin
  .inputrc
  .npmrc
  .osx
  .shrc
  .spacemacs
  .sshrc
  .tmux.conf
  .vim
  .vimrc
  .wgetrc
  .zprofile
  .zshenv
  .zshrc
)

echo "=== Home Directory Dotfiles ==="
for dotfile in "${home_dotfiles[@]}"; do
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

config_dirs=(
  delta
  helix
  litellm
  mise
  neovide
  ranger
  yamllint
  yazi
  zed
  zellij
)

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

# Vim local config
if [[ ! -f "$HOME/.vimrc.local" ]]; then
  if prompt_yes "Setup vim local config (~/.vimrc.local from example)?"; then
    cp "$DOTFILES_PATH/.vimrc.local.example" "$HOME/.vimrc.local"
    echo "  Copied: ~/.vimrc.local"
  fi
else
  echo "Skipping ~/.vimrc.local (already exists)"
fi

# Intelephense license (optional - for PHP development)
if prompt_no "Setup Intelephense license (PHP LSP)?"; then
  mkdir -p ~/intelephense
  read -p "Enter Intelephense license key: " -r intelephense_license
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
