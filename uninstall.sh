#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dotfiles.conf"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

removed=0
skipped=0

prompt_yes() {
  local message="$1"
  read -p "$message [Y/n]: " -n 1 -r
  echo
  [[ ! $REPLY =~ ^[Nn]$ ]]
}

remove_symlink() {
  local target="$1"
  local expected="$2"
  if [[ -L "$target" ]]; then
    local actual
    actual="$(readlink "$target")"
    if [[ "$actual" == "$expected" ]]; then
      if prompt_yes "  Remove symlink $target -> $actual?"; then
        rm -f "$target"
        echo -e "  ${GREEN}Removed${NC}: $target"
        ((removed++))
      else
        echo -e "  ${YELLOW}Skipped${NC}: $target"
        ((skipped++))
      fi
    else
      echo -e "  ${YELLOW}Skipped${NC}: $target -> $actual (not ours)"
      ((skipped++))
    fi
  elif [[ -e "$target" ]]; then
    echo -e "  ${YELLOW}Skipped${NC}: $target (not a symlink)"
    ((skipped++))
  fi
}

remove_file() {
  local target="$1"
  if [[ -f "$target" ]]; then
    if prompt_yes "  Remove file $target?"; then
      rm -f "$target"
      echo -e "  ${GREEN}Removed${NC}: $target"
      ((removed++))
    else
      echo -e "  ${YELLOW}Skipped${NC}: $target"
      ((skipped++))
    fi
  elif [[ -d "$target" ]]; then
    if prompt_yes "  Remove directory $target?"; then
      rm -rf "$target"
      echo -e "  ${GREEN}Removed${NC}: $target"
      ((removed++))
    else
      echo -e "  ${YELLOW}Skipped${NC}: $target"
      ((skipped++))
    fi
  fi
}

echo ""
echo -e "${BOLD}=== Dotfiles Uninstall ===${NC}"
echo ""

# =============================================================================
# Home Directory Dotfiles
# =============================================================================

echo "=== Home Directory Dotfiles ==="
for dotfile in "${home_dotfiles[@]}"; do
  remove_symlink "$HOME/$dotfile" "$DOTFILES_PATH/$dotfile"
done

# =============================================================================
# Config Directory Symlinks
# =============================================================================

echo ""
echo "=== Config Directory Symlinks ==="
for config_dir in "${config_dirs[@]}"; do
  remove_symlink "$HOME/.config/$config_dir" "$DOTFILES_PATH/.config/$config_dir"
done

# Neovim config
remove_symlink "$HOME/.config/nvim" "$DOTFILES_PATH/.vim"

# =============================================================================
# Copied Files
# =============================================================================

echo ""
echo "=== Copied Files ==="
remove_file "$HOME/.gitconfig.local"
remove_file "$HOME/.vimrc.local"
remove_file "$HOME/intelephense"
remove_file "$DOTFILES_PATH/.gitalias"

# =============================================================================
# Sudoers timeout
# =============================================================================

if [[ -f /private/etc/sudoers.d/timeout ]]; then
  echo ""
  echo "=== Sudoers ==="
  if prompt_yes "  Remove /private/etc/sudoers.d/timeout (requires sudo)?"; then
    sudo rm -f /private/etc/sudoers.d/timeout && \
      echo -e "  ${GREEN}Removed${NC}: /private/etc/sudoers.d/timeout" && \
      ((removed++))
  else
    echo -e "  ${YELLOW}Skipped${NC}: /private/etc/sudoers.d/timeout"
    ((skipped++))
  fi
fi

# =============================================================================
# Done
# =============================================================================

echo ""
echo -e "${BOLD}=== Uninstall Complete ===${NC}"
echo -e "  Removed: ${GREEN}$removed${NC}  Skipped: ${YELLOW}$skipped${NC}"
echo ""
echo "The ~/.dotfiles directory itself was NOT removed."
echo "To finish: rm -rf ~/.dotfiles"
