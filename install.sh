#!/usr/bin/env bash

# Install Command Line Tools.
sudo xcode-select --install

# Mac software updates.
softwareupdate --all --install --force

# Install Brew.
if ! type brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# File managers
brew install xplr
brew install yazi
brew install joshuto
brew install clifm

# yazi themes
ya pkg add dangooddd/kanagawa

# Install Brew packages.
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
brew install ccat
brew install cfn-lint
brew install chafa # Convert image to ASCII for ranger
brew install charmbracelet/tap/crush
brew install claude
brew install colordiff
brew install comby
brew install composer
brew install coreutils
brew install cowsay
brew install curl
brew install cw
brew install dateutils
brew install devutils
brew install diffr
brew install difftastic
brew install docker
brew install docker-compose
brew install editorconfig
brew install exa
brew install exiftool # Extract file information for ranger
brew install eza      # Pretty `ls` alternative for ranger
brew install fd
brew install findutils
brew install fx
brew install fzf
brew install fzy
brew install gawk
brew install gh
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
brew install jless
brew install jnv
brew install jordanbaird-ice
brew install jq
brew install lolcat
brew install lsd
brew install mediainfo # Extract media information for ranger
brew install ms-jpq/sad/sad
brew install neovide
brew install neovim
brew install netcat
brew install nnn
brew install node
brew install nvm
brew install odt2txt # Convert OpenDocument to txt for ranger
brew install openjdk@11
brew install pandoc # Convert documents for ranger
brew install php
brew install poppler # PDR preview for cli file managers
brew install pure
brew install python
brew install ranger
brew install repomix
brew install resvg # SVG preview for cli file managers/
brew install rg
brew install ripgrep
brew install rsync
brew install saulpw/vd/visidata
brew install shellcheck
brew install sqlite
brew install sst/tap/opencode
brew install stats
brew install tccutil
brew install tflint
brew install the_silver_searcher
brew install tig
brew install tmux
brew install tree
brew install tree-sitter
brew install unar
brew install unzip
brew install vim
brew install viu
brew install wget
brew install whois
brew install xq
brew install yarn
brew install yq
brew install zoxide
brew install zsh
brew install zsh-autosuggestions
brew link docker
brew tap buo/cask-upgrade
brew tap lucagrulla/tap

# Setup Java.
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

# Install Brew cask packages.
brew install --cask 1password
brew install --cask alfred
brew install --cask alt-tab
brew install --cask beekeeper-studio
brew install --cask chatgpt
brew install --cask codeedit
brew install --cask cursor
brew install --cask dash
brew install --cask db-browser-for-sqlite
brew install --cask drawio
brew install --cask dropbox
brew install --cask firefox
brew install --cask github
brew install --cask google-chrome
brew install --cask google-drive
brew install --cask hyper
brew install --cask insomnia
brew install --cask istat-menus
brew install --cask iterm2
brew install --cask jupyterlab
brew install --cask kiro
brew install --cask macdown # Markdown with Mermaid support
brew install --cask macs-fan-control
brew install --cask mark-text
brew install --cask marta
brew install --cask microsoft-teams
brew install --cask notion
brew install --cask ollama
brew install --cask onyx
brew install --cask oracle-jdk
brew install --cask orbstack
brew install --cask postman
brew install --cask redisinsight
brew install --cask sequel-pro
brew install --cask sourcetree
brew install --cask spectacle
brew install --cask spotify
brew install --cask tabby
brew install --cask todoist
brew install --cask vimr
brew install --cask visual-studio-code
brew install --cask vlc
brew install --cask windsurf
brew install --cask zed
brew install --cask zoom

# Install Brew cask personal packager.
read -p 'Install Brew personal packages? (y/n): ' -n 1 -r
brew_cask_packages_personal=(
  'whatsapp'
  'telegram-desktop'
  'webtorrent'
  'betaflight-configurator'
  'ledger-live'
)
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo 'Installing personal Brew packages...'

  for package in "${brew_cask_packages_personal[@]}"; do
    echo "Installing Brew cask package '$package'..."
    brew install --cask "$package"
  done

  echo "All packages installed successfully!"
fi

# Install Brew cask work packages.
brew install --cask slack

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

# NVim language servers.
nvim +'LspInstall --sync bashls' +qall
nvim +'LspInstall --sync cssls' +qall
nvim +'LspInstall --sync cssmodules_ls' +qall
nvim +'LspInstall --sync diagnosticls' +qall
nvim +'LspInstall --sync dockerls' +qall
nvim +'LspInstall --sync emmet_ls' +qall
nvim +'LspInstall --sync eslint' +qall
nvim +'LspInstall --sync graphql' +qall
nvim +'LspInstall --sync html' +qall
nvim +'LspInstall --sync intelephense' +qall
nvim +'LspInstall --sync jedi_language_server' +qall
nvim +'LspInstall --sync jsonls' +qall
nvim +'LspInstall --sync lemminx' +qall
nvim +'LspInstall --sync marksman' +qall
nvim +'LspInstall --sync phpactor' +qall
nvim +'LspInstall --sync pyright' +qall
nvim +'LspInstall --sync sourcery' +qall
nvim +'LspInstall --sync sqlls' +qall
nvim +'LspInstall --sync lsp_ls' +qll
nvim +'LspInstall --sync terraformls' +qall
nvim +'LspInstall --sync tflint' +qall
nvim +'LspInstall --sync tsserver' +qall
nvim +'LspInstall --sync vimls' +qall
nvim +'LspInstall --sync yamlls' +qall

# Install latest Node version for NVM.
nvm install --lts

# Install Neovim libraries.
pip3 install pynvim --upgrade
pip3 install neovim --upgrade
npm install --global neovim

pip3 install saws

# Install Typescript.
brew install ts-node
brew install typescript

npm install --global fix-package-conflicts
npm install --global lehre # Required to generate JS docblocks in Vim (LJSDoc).
npm install --global uv

# Install LLM cli tools
bunx ccusage
npm install --global @anthropic-ai/claude-code
npm install --global @github/copilot
npm install --global @google/gemini-cli
npm install --global @openai/codex
npm install --global @qwen-code/qwen-code@latest
npm install --global opencode-ai

# automem
# https://github.com/verygoodplugins/automem
mkdir -p ~/Code/vendor
git clone https://github.com/verygoodplugins/automem ~/Code/vendor/automem
cd ~/Code/vendor/automem
make dev
npm install -g @verygoodplugins/mcp-automem
npx @verygoodplugins/mcp-automem setup # AutoMem Endpoint: http://localhost:8001

# Install MCP servers.
mkdir ~/.mcp                              # Used by @modelcontextprotocol/server-memory
npm install -g @cocal/google-calendar-mcp
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-memory
npm install -g @playwright/mcp@latest
npm install -g @upstash/context7-mcp
npm install -g gemini-mcp-tool
npx -y @smithery/cli install @abhiz123/todoist-mcp-server --client claude
pip install lean
pip install mcp-server-fetch
pip install mcp-server-git
uv tool install leann-core
uv tool install 'cased-kit[all]'
uv tool install codetoprompt

# Install coc.nvim plugins.
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-css' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-dictionary' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-docker' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-eslint' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-fzf-preview' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-html' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-json' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-markdownlint' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-omni' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-phpactor' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-phpls' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-pyright' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-sh' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-syntax' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-tabnine' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-tag' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-tsserver' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-vimlsp' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-word' +qall
nvim --cmd 'let g:use_coc = 1' +'CocInstall -sync coc-yaml' +qall
nvim --cmd 'let g:use_coc = 1' +'CocUpdateSync' +qall

# Install Treesitter plugins.
nvim +'TSInstall! bash' +qall
nvim +'TSInstall! comment' +qall
nvim +'TSInstall! css' +qall
nvim +'TSInstall! graphql' +qall
nvim +'TSInstall! help' +qall
nvim +'TSInstall! html' +qall
nvim +'TSInstall! http' +qall
nvim +'TSInstall! javascript' +qall
nvim +'TSInstall! jsdoc' +qall
nvim +'TSInstall! json' +qall
nvim +'TSInstall! json5' +qall
nvim +'TSInstall! jsonc' +qall
nvim +'TSInstall! latex' +qall
nvim +'TSInstall! markdown' +qall
nvim +'TSInstall! markdown_inline' +qall
nvim +'TSInstall! php' +qall
nvim +'TSInstall! phpdoc'
nvim +'TSInstall! regex' +qall
nvim +'TSInstall! scss' +qall
nvim +'TSInstall! typescript' +qall
nvim +'TSInstall! typst' +qall
nvim +'TSInstall! vim' +qall
nvim +'TSInstall! yaml' +qall
nvim +'TSUpdate all' +qall

# Setup Copilot.
nvim +'Copilot setup'
