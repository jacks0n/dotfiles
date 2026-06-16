#!/usr/bin/env bash
# setup.server.sh — Bootstrap an Ubuntu Server for home lab use.
#
# Idempotent. Safe to re-run. Each section skips already-installed components.
# System bootstrap only — toolchain (Linuxbrew + packages) lives in
# install.server.sh, which runs as the target user afterwards.
#
# Usage:
#   sudo ./setup.server.sh [hostname]
#
# Targets: Ubuntu Server 22.04+ (also works in Proxmox LXCs with nesting=1)

set -euo pipefail

# =============================================================================
# Configuration — edit these for your environment
# =============================================================================

readonly TIMEZONE="Australia/Melbourne"
readonly LOCALE="en_AU.UTF-8"
readonly TARGET_USER="${SUDO_USER:-$USER}"
readonly TARGET_HOME=$(eval echo "~$TARGET_USER")
readonly DOTFILES_REPO="https://github.com/jacks0n/dotfiles.git"
readonly DOTFILES_PATH="$TARGET_HOME/.dotfiles"

# =============================================================================
# Helpers
# =============================================================================

log()  { printf '\e[32m[+]\e[0m %s\n' "$*"; }
warn() { printf '\e[33m[!]\e[0m %s\n' "$*"; }
err()  { printf '\e[31m[x]\e[0m %s\n' "$*" >&2; }
step() { printf '\n\e[1;34m=== %s ===\e[0m\n' "$*"; }

require_root() {
  if [[ $EUID -ne 0 ]]; then
    err "Run with sudo: sudo $0 ${*:-}"
    exit 1
  fi
}

as_user() { sudo -u "$TARGET_USER" -- "$@"; }

installed() { command -v "$1" &>/dev/null; }

apt_install() { apt-get install -y -qq "$@"; }

prompt_yes() {
  local message="$1"
  read -p "$message [Y/n]: " -n 1 -r
  echo
  [[ ! $REPLY =~ ^[Nn]$ ]]
}

prompt_no() {
  local message="$1"
  read -p "$message [y/N]: " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]]
}

is_correct_symlink() {
  local target="$1"
  local expected="$2"
  [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$expected" ]]
}

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
      as_user rm -rf "$target"
      return 0
    fi
    return 1
  fi
  return 0
}

# =============================================================================
# 1. System Configuration
# =============================================================================

configure_system() {
  step "System"

  if [[ -n "${1:-}" ]]; then
    hostnamectl set-hostname "$1"
    log "Hostname: $1"
  else
    log "Hostname: $(hostname) (pass hostname as arg to change)"
  fi

  timedatectl set-timezone "$TIMEZONE"
  log "Timezone: $TIMEZONE"

  locale-gen "$LOCALE" en_US.UTF-8 >/dev/null 2>&1
  update-locale LANG="$LOCALE"
  log "Locale: $LOCALE"

  apt-get update -qq
  apt-get upgrade -y -qq
  apt-get dist-upgrade -y -qq
  apt-get autoremove -y -qq
  log "Packages updated"
}

# =============================================================================
# 2. Essentials (minimal apt — full toolchain comes from install.server.sh)
# =============================================================================

install_essentials() {
  step "Essentials"

  sudo apt-get --yes install \
    apt-transport-https \
    build-essential \
    ca-certificates \
    file \
    lsb-release \
    procps \
    software-properties-common \
    sudo

  log "Essential packages installed"
}

# =============================================================================
# 3. SSH Hardening
# =============================================================================

harden_ssh() {
  step "SSH Hardening"

  local sshd_config="/etc/ssh/sshd_config"
  [[ ! -f "${sshd_config}.orig" ]] && cp "$sshd_config" "${sshd_config}.orig"

  # Drop-in config — avoids clobbering the distro's sshd_config
  mkdir -p /etc/ssh/sshd_config.d
  cat > /etc/ssh/sshd_config.d/90-hardening.conf <<'EOF'
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
X11Forwarding no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
EOF

  if sshd -t 2>/dev/null; then
    systemctl restart sshd
    log "Key-only auth, no root login, no password"
  else
    err "SSH config invalid — reverted"
    rm -f /etc/ssh/sshd_config.d/90-hardening.conf
    return 1
  fi
}

# =============================================================================
# 4. Unattended Upgrades
# =============================================================================

configure_unattended_upgrades() {
  step "Unattended Upgrades"

  apt_install unattended-upgrades

  cat > /etc/apt/apt.conf.d/50unattended-upgrades <<'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}";
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
    "${distro_id}ESM:${distro_codename}-infra-security";
};
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
EOF

  cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

  systemctl enable --now unattended-upgrades >/dev/null 2>&1
  log "Security patches auto-install, no auto-reboot"
}

# =============================================================================
# 5. Tailscale
# =============================================================================

install_tailscale() {
  step "Tailscale"

  if ! installed tailscale; then
    curl -fsSL https://tailscale.com/install.sh | sh
    log "Tailscale installed"
  else
    log "Tailscale already installed"
  fi

  # accept-dns:    MagicDNS for hostname resolution (e.g. atlas.tail*.ts.net).
  #                Harmless — keep on everywhere.
  # accept-routes: OFF. This server is already on the LAN. Accepting subnet
  #                routes from another node would tunnel all LAN traffic through
  #                Tailscale, breaking local connectivity. Only enable on remote
  #                devices that need to reach LAN hosts without Tailscale.
  # advertise-exit-node: ON. Lets clients route internet traffic through this
  #                host when off home WiFi (hotel, airport, overseas). Requires
  #                one-time approval at https://login.tailscale.com/admin/machines.
  #                On clients, pair with --exit-node-allow-lan-access=true so
  #                local LAN devices stay reachable when the exit node is on —
  #                making the config set-and-forget across home and away.
  tailscale set --accept-dns=true --accept-routes=false --advertise-exit-node=true
  log "Tailscale configured (accept-dns, no accept-routes, advertise-exit-node)"

  if ! tailscale status &>/dev/null; then
    warn "Authenticate with: sudo tailscale up"
  fi
}

# =============================================================================
# 6. Docker CE
# =============================================================================

install_docker() {
  step "Docker"

  if ! installed docker; then
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    local codename
    codename=$(. /etc/os-release && echo "$VERSION_CODENAME")
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $codename stable" \
      > /etc/apt/sources.list.d/docker.list

    apt-get update -qq
    apt_install docker-ce docker-ce-cli containerd.io \
      docker-buildx-plugin docker-compose-plugin
    systemctl enable --now docker
    log "Docker CE installed"
  else
    log "Docker already installed"
  fi

  if ! id -nG "$TARGET_USER" | grep -qw docker; then
    usermod -aG docker "$TARGET_USER"
    log "User '$TARGET_USER' added to docker group"
  fi
}

# =============================================================================
# 7. Hardware Monitoring
# =============================================================================

install_monitoring() {
  step "Hardware Monitoring"

  apt_install smartmontools lm-sensors

  systemctl enable --now smartd >/dev/null 2>&1 || true
  log "smartmontools + lm-sensors installed"
  log "Run 'sudo sensors-detect' to configure temperature sensors"
}

# =============================================================================
# 8. Dotfiles (clone)
# =============================================================================

clone_dotfiles() {
  step "Dotfiles (clone)"

  if [[ -d "$DOTFILES_PATH/.git" ]]; then
    log "Dotfiles present at $DOTFILES_PATH"
  else
    as_user git clone "$DOTFILES_REPO" "$DOTFILES_PATH"
    log "Dotfiles cloned to $DOTFILES_PATH"
  fi
}

# =============================================================================
# 9. Dotfiles (symlink) — mirrors setup.sh, scoped to $TARGET_USER
# =============================================================================

symlink_dotfiles() {
  step "Dotfiles (symlink)"

  # shellcheck disable=SC1091
  source "$DOTFILES_PATH/dotfiles.conf"

  echo "--- Home Directory Dotfiles ---"
  for dotfile in "${home_dotfiles[@]}"; do
    local target="$TARGET_HOME/$dotfile"
    local src="$DOTFILES_PATH/$dotfile"

    if is_correct_symlink "$target" "$src"; then
      echo "Already linked: ~/$dotfile"
      continue
    fi
    if ! handle_existing "$target"; then
      echo "  Skipped: ~/$dotfile"
      continue
    fi
    if prompt_yes "Symlink ~/$dotfile?"; then
      as_user ln -s "$src" "$target"
      echo "  Created: ~/$dotfile -> $src"
    fi
  done

  echo ""
  echo "--- Config Directory Symlinks ---"
  as_user mkdir -p "$TARGET_HOME/.config"

  for config_dir in "${config_dirs[@]}"; do
    local target="$TARGET_HOME/.config/$config_dir"
    local src="$DOTFILES_PATH/.config/$config_dir"

    if is_correct_symlink "$target" "$src"; then
      echo "Already linked: ~/.config/$config_dir"
      continue
    fi
    if ! handle_existing "$target"; then
      echo "  Skipped: ~/.config/$config_dir"
      continue
    fi
    if prompt_yes "Symlink ~/.config/$config_dir?"; then
      as_user ln -s "$src" "$target"
      echo "  Created: ~/.config/$config_dir -> $src"
    fi
  done

  echo ""
  echo "--- Special Setups ---"

  local nvim_target="$TARGET_HOME/.config/nvim"
  local nvim_src="$DOTFILES_PATH/.vim"
  if is_correct_symlink "$nvim_target" "$nvim_src"; then
    echo "Already linked: ~/.config/nvim"
  elif ! handle_existing "$nvim_target"; then
    echo "  Skipped: ~/.config/nvim"
  elif prompt_yes "Setup Neovim config (~/.config/nvim -> ~/.dotfiles/.vim)?"; then
    as_user ln -s "$nvim_src" "$nvim_target"
    echo "  Created: ~/.config/nvim -> $nvim_src"
  fi

  if prompt_yes "Setup personal git config (~/.gitconfig.local)?"; then
    if [[ -f "$TARGET_HOME/.gitconfig.local" ]]; then
      echo "  File already exists: ~/.gitconfig.local"
      if prompt_yes "  Overwrite it?"; then
        as_user cp "$DOTFILES_PATH/.gitconfig.personal" "$TARGET_HOME/.gitconfig.local"
        echo "  Copied: ~/.gitconfig.local"
      else
        echo "  Skipped: ~/.gitconfig.local"
      fi
    else
      as_user cp "$DOTFILES_PATH/.gitconfig.personal" "$TARGET_HOME/.gitconfig.local"
      echo "  Copied: ~/.gitconfig.local"
    fi
  fi

  for suffix in before after; do
    local local_file="$TARGET_HOME/.vimrc.$suffix.local"
    local example_file="$DOTFILES_PATH/.vimrc.$suffix.local.example"
    if [[ ! -f "$local_file" ]] && [[ -f "$example_file" ]]; then
      if prompt_yes "Setup vim local config (~/.vimrc.$suffix.local from example)?"; then
        as_user cp "$example_file" "$local_file"
        echo "  Copied: ~/.vimrc.$suffix.local"
      fi
    elif [[ -f "$local_file" ]]; then
      echo "Skipping ~/.vimrc.$suffix.local (already exists)"
    fi
  done

  if prompt_yes "Download GitAlias (extended git aliases)?"; then
    as_user curl -fsSL https://raw.githubusercontent.com/GitAlias/gitalias/main/gitalias.txt \
      -o "$DOTFILES_PATH/.gitalias"
    echo "  Downloaded: $DOTFILES_PATH/.gitalias"
  fi
}

# =============================================================================
# Main
# =============================================================================

main() {
  require_root

  printf '\n  Server Bootstrap\n'
  printf '  User: %s | Home: %s\n\n' "$TARGET_USER" "$TARGET_HOME"

  configure_system "${1:-}"
  install_essentials
  harden_ssh
  configure_unattended_upgrades
  install_tailscale
  install_docker
  install_monitoring
  clone_dotfiles
  symlink_dotfiles

  step "Done"
  log "Server bootstrapped. Remaining manual steps:"
  warn "1. sudo tailscale up                              — authenticate Tailscale"
  warn "2. sudo sensors-detect                            — configure temp sensors"
  warn "3. Log out + back in                              — pick up docker group"
  warn "4. cd ~/.dotfiles && ./install.server.sh          — install Linuxbrew + toolchain"
}

main "$@"
