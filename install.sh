#!/usr/bin/env bash
# vim: filetype=sh

# Install Command Line Tools.
sudo xcode-select --install

softwareupdate --all --install --force

# Install Brew.
if ! type brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
brew install betterzip
brew install bfg
brew install brew-cask-completion
brew install bun
brew install chafa # Convert image to ASCII for ranger/yazi
brew install charmbracelet/tap/crush
brew install claude
brew install colordiff
brew install composer
brew install coreutils
brew install cowsay
brew install curl
brew install dateutils
brew install devutils
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
brew install jordanbaird-ice
brew install jq
brew install lolcrab
brew install lsd
brew install mediainfo # Extract media information for ranger
brew install mise
brew install ms-jpq/sad/sad
brew install neovide
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
brew install shellcheck
brew install shfmt
brew install sqlite
brew install stats
brew install tccutil
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
brew link docker
brew tap buo/cask-upgrade

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

# Setup Java.
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

# Setup Rust.
rustup default stable

# Install Brew cask packages - core
brew install --cask alfred
brew install --cask alt-tab
brew install --cask dash
brew install --cask dropbox
brew install --cask firefox
brew install --cask github
brew install --cask google-chrome
brew install --cask insomnia
brew install --cask istat-menus
brew install --cask iterm2
brew install --cask libreoffice # Yazi preview
brew install --cask macdown # Markdown with Mermaid support
brew install --cask mark-text
brew install --cask marta
brew install --cask microsoft-teams
brew install --cask notion
brew install --cask orbstack
brew install --cask postman
brew install --cask sourcetree
brew install --cask spectacle
brew install --cask spotify
brew install --cask tabby
brew install --cask vimr
brew install --cask zed

# Install Brew cask packages - optional
brew_cask_packages_optional=(
  '1password'
  'beekeeper-studio'
  'chatgpt'
  'db-browser-for-sqlite'
  'drawio'
  'google-drive'
  'jupyterlab'
  'ollama'
  'oracle-jdk'
  'redisinsight'
  'slack'
  'todoist'
  'visual-studio-code'
  'vlc'
  'zoom'
)
for package in "${brew_cask_packages_optional[@]}"; do
  read -p "Install $package? [Y/n]: " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    brew install --cask "$package"
  fi
done

# Install personal git config.
read -p 'Install personal git config? [Y/n]: ' -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  ln -sf ~/.dotfiles/.gitconfig.personal ~/.gitconfig.local
  echo 'Personal git config linked to ~/.gitconfig.local'
fi

# Install Brew cask personal packages.
read -p 'Install Brew personal packages? [y/n]: ' -n 1 -r
echo
brew_cask_packages_personal=(
  'betaflight-configurator'
  'ledger-live'
  'telegram-desktop'
  'webtorrent'
  'whatsapp'
)
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo 'Installing personal Brew packages...'

  for package in "${brew_cask_packages_personal[@]}"; do
    echo "Installing Brew cask package '$package'..."
    brew install --cask "$package"
  done

  echo 'All packages installed successfully!'
fi

# Install Brew cask fonts.
brew install --cask font-droid-sans-mono-nerd-font
brew install --cask font-fantasque-sans-mono-nerd-font
brew install --cask font-fira-mono-nerd-font
brew install --cask font-hack-nerd-font
brew install --cask font-inconsolata-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-liberation-mono-for-powerline
brew install --cask font-mononoki-nerd-font
brew install --cask font-sf-mono-nerd-font
brew install --cask font-ubuntu-mono-nerd-font

# Install Quick Look plugins.
brew install --cask QLPrettyPatch      # QuickLook generator for patch files.
brew install --cask apparency          # Preview the contents of a macOS app.
brew install --cask qladdict           # Preview subtitle (.srt) files.
brew install --cask qlcolorcode        # Preview source code files with syntax highlighting.
brew install --cask qlimagesize        # Display image size and resolution.
brew install --cask qlmarkdown         # Preview Markdown files.
brew install --cask qlstephen          # Preview plain text files without or with unknown file extension.
brew install --cask qlvideo            # Preview most types of video files, as well as their thumbnails, cover art and metadata.
brew install --cask quicklook-json     # Preview JSON files.
brew install --cask quicklook-pat      # Preview Adobe Photoshop pattern files.
brew install --cask quicklookapk       # Preview Android APK files.
brew install --cask quicklookase       # Preview Adobe ASE Color Swatches.
brew install --cask suspicious-package # Preview the contents of a standard Apple installer package.
brew install --cask syntax-highlight   # Preview many different source code files.
sudo xattr -rd com.apple.quarantine /Library/QuickLook
qlmanage -r
qlmanage -r cache
killall Finder

# Alfred.
npm install --global alfred-updater
npm install --global alfred-caniuse

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
npm install --global @anthropic-ai/claude-code
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

nvim --cmd 'let g:use_coc = 1' +'CocUpdateSync' +qall

nvim --headless -c 'lua require("plugins.treesitter")' -c 'TSInstallAll' -c 'qall'
nvim +'Copilot setup'
