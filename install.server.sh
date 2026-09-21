#!/usr/bin/env bash
# vim: filetype=sh
# install.server.sh — Install Linuxbrew + toolchain on a headless Linux server.
#
# Run AFTER setup.server.sh, as the target user (NOT root). Linuxbrew refuses
# to install as root.

# Refuse to run as root.
if [[ $EUID -eq 0 ]]; then
  echo "Do not run as root. Linuxbrew refuses to install as root."
  exit 1
fi

# Install Linuxbrew.
if ! type brew &>/dev/null; then
  sudo apt-get install build-essential procps curl file git
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for the current session.
  if [[ -d /home/linuxbrew/.linuxbrew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ -d "$HOME/.linuxbrew" ]]; then
    eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
  fi
fi

# Yazi file manager
brew install yazi
ya pkg install

# Install Brew packages - core
brew install 7zip    # Archive preview for cli file managers
brew install ast-grep
brew install awscli
brew install bash
brew install bash-completion
brew install bat
brew install bfg
brew install bun
brew install chafa # Convert image to ASCII for ranger/yazi
brew install charmbracelet/tap/crush
brew install colordiff
brew install comby
brew install composer
brew install coreutils
brew install cowsay
brew install curl
brew install dateutils
brew install diffr
brew install difftastic
brew install docker
brew install docker-compose
brew install editorconfig
brew install exiftool # Extract file information for ranger
brew install eza      # pretty `ls` alternative (exa fork)
brew install fd
brew install findutils
brew install fx
brew install fzf
brew install fzy
brew install gawk
brew install git
brew install git-delta
brew install glow # Render markdown for ranger
brew install gnu-sed
brew install gnu-tar
brew install go # Required for SQL language server.
brew install grep
brew install htop
brew install imagemagick
brew install jesseduffield/lazygit/lazygit
brew install jless # JSON viewer
brew install jnv # Interactive JSON filter using jq
brew install jq
brew install lolcrab
brew install lsd
brew install mediainfo # Extract media information for ranger
brew install mise
brew install ms-jpq/sad/sad
brew install neovim
brew install netcat
brew install node
brew install odt2txt # Convert OpenDocument to txt for ranger
brew install openjdk@11
brew install pandoc # Convert documents for ranger
brew install php
brew install poppler # PDF preview for cli file managers
brew install pure
brew install python
brew install ranger
brew install resvg # SVG preview for cli file managers
brew install ripgrep
brew install rsync
brew install rustup
brew install saulpw/vd/visidata
brew install semgrep
brew install shellcheck
brew install sd
brew install shfmt
brew install sqlite
brew install svgo
brew install the_silver_searcher
brew install tmux
brew install tree
brew install tree-sitter
brew install ts-node
brew install typescript
brew install unar
brew install unzip
brew install uv
brew install vim
brew install wget
brew install whois
brew install xq
brew install yq
brew install zellij
brew install zoxide
brew install zsh
brew install zsh-autosuggestions
brew install tree-sitter-cli

# Install Brew packages - optional
brew_packages_optional=(
  'cfn-lint'
  'gh'
  'tflint'
  'viu'
  'yarn'
)
for package in "${brew_packages_optional[@]}"; do
  read -p "Install $package? [Y/n]: " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    brew install "$package"
  fi
done

# Setup Rust. See install.sh for why the profile is set before installing.
rustup set profile minimal
rustup default stable
rustup component add clippy rustfmt rust-src

# Default login shell is handled portably by setup.sh.

# Install personal git config.
read -p 'Install personal git config? [Y/n]: ' -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  ln -sf ~/.dotfiles/.gitconfig.personal ~/.gitconfig.local
  echo 'Personal git config linked to ~/.gitconfig.local'
fi

npm --global install npm-check-updates

# Install all Mason packages (LSP servers, linters, formatters).
nvim --headless -c 'MasonInstallAll'

# Install Neovim libraries.
uv pip install --system pynvim --upgrade
uv pip install --system neovim --upgrade
npm install --global neovim

# Install pip packages - optional
pip_packages_optional=(
  'saws'
)
for package in "${pip_packages_optional[@]}"; do
  read -p "Install $package? [Y/n]: " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    uv pip install --system "$package"
  fi
done

npm install --global fix-package-conflicts
npm install --global lehre # Required to generate JS docblocks in Vim (LJSDoc).

# Install LLM cli tools
bunx ccusage
npm install --global @github/copilot
npm install --global @google/gemini-cli
npm install --global @openai/codex
npm install --global @qwen-code/qwen-code@latest
npm install --global opencode-ai

# Install MCP servers.
mkdir -p ~/.mcp                           # Used by @modelcontextprotocol/server-memory
npm install -g @azure/mcp@latest
npm install -g @cocal/google-calendar-mcp
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-memory
npm install -g @playwright/mcp@latest
npm install -g @upstash/context7-mcp
npm install -g gemini-mcp-tool
npx -y @smithery/cli install @abhiz123/todoist-mcp-server --client claude
uv pip install --system mcp-server-fetch
uv pip install --system mcp-server-git
uv tool install 'cased-kit[all]'
uv tool install mcp-proxy
uv tool install codetoprompt
uv tool install leann-core

nvim --headless -c 'lua require("plugins.treesitter")' -c 'TSInstallAll' -c 'qall'
