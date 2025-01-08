#!/usr/bin/env bash

# Install Command Line Tools.
sudo xcode-select --install

# Mac software updates.
softwareupdate --all --install --force

# Install Brew.
if ! type brew &>/dev/null ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install zim.
curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

# Install Brew packages.
brew install tflint
brew install awscli
brew install bash
brew install bash-completion
brew install ast-grep
brew install bat
brew install betterzip
brew install bfg
brew install brave-browser
brew install brew-cask-completion
brew install ccat
brew install claude
# brew install chezmoi
# brew install cmake # Required for YouCompleteMe.
# brew install hashicorp/tap/terraform-ls
brew install colordiff
brew install composer
brew install coreutils
brew install cowsay
brew install stats
brew install curl
brew install dateutils
brew install devutils
brew install diffr
brew install difftastic
brew install docker
brew link docker
brew install docker-compose
brew install editorconfig
brew install exa
brew install fd
brew install findutils
brew install fx
brew install fzf
brew install fzy
brew install gawk
brew install gh
brew install git
brew install git-delta
brew install gnu-sed
brew install gnu-tar
brew install go # Required for SQL language server.
brew install grep
brew install htop
brew install jesseduffield/lazygit/lazygit
brew install jordanbaird-ice
brew install jq
brew install lolcat
brew install lsd
brew install ms-jpq/sad/sad
brew install neovide
brew install neovim
brew install netcat
brew install nnn
brew install node
brew install nvm
# brew install openapi-generator
brew install openjdk@11
brew install php
brew install pure
brew install python
brew install ranger
brew install ripgrep
brew install rsync
brew install saulpw/vd/visidata
brew install shellcheck
brew install skype
brew install sqlite
# brew install starship
# brew install svn
brew install tccutil
brew install the_silver_searcher
brew install tig
brew install tmux
brew install tree
brew install tree-sitter
brew install unar
# brew install universal-ctags
brew install unzip
brew install vim
brew install viu
brew install watchman
brew install wget
brew install whois
brew install yarn
brew install yq
brew install z
brew install zsh
brew install zsh-autosuggestions
brew tap buo/cask-upgrade
brew tap lucagrulla/tap
brew install cw

# Setup Java.
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

# Install Brew cask packages.
# Optional.
brew install --cask 1password
brew install --cask webtorrent
brew install --cask airflow
brew install --cask ollama
brew install --cask alfred
brew install --cask arq
brew install --cask beekeeper-studio
brew install --cask chatgpt --no-quarantine
brew install --cask codeedit
brew install --cask dash
brew install --cask db-browser-for-sqlite
brew install --cask drawio
brew install --cask dropbox
brew install --cask evernote
brew install --cask fig
brew install --cask firefox
brew install --cask github
brew install --cask google-chrome
brew install --cask google-drive
brew install --cask hyper
brew install --cask insomnia
brew install --cask istat-menus
brew install --cask iterm2
brew install --cask jupyterlab
brew install --cask macs-fan-control
brew install --cask masscode
brew install --cask microsoft-teams
brew install --cask notion
brew install --cask oracle-jdk
brew install --cask orbstack
brew install --cask postman
brew install --cask r rstudio
brew install --cask redisinsight
brew install --cask sequel-pro
brew install --cask sourcetree
brew install --cask spectacle
brew install --cask spotify
brew install --cask tabby
brew install --cask telegram-desktop
brew install --cask todoist
brew install --cask vimr
brew install --cask visual-studio-code
brew install --cask vlc
brew install --cask whatsapp
brew install --cask zettlr
brew install --cask zoom
brew tap lencx/chatgpt https://github.com/lencx/ChatGPT.git

# Install Brew cask work packages.
brew install --cask slack

# Install Brew cask fonts.
brew install --cask font-sf-mono-nerd-font
brew install --cask homebrew/cask-fonts/font-droid-sans-mono-nerd-font
brew install --cask homebrew/cask-fonts/font-fantasque-sans-mono-nerd-font
brew install --cask homebrew/cask-fonts/font-fira-mono-nerd-font
brew install --cask homebrew/cask-fonts/font-hack-nerd-font
brew install --cask homebrew/cask-fonts/font-inconsolata-nerd-font
brew install --cask homebrew/cask-fonts/font-jetbrains-mono-nerd-font
brew install --cask homebrew/cask-fonts/font-liberation-mono-for-powerline
brew install --cask homebrew/cask-fonts/font-mononoki-nerd-font
brew install --cask homebrew/cask-fonts/font-ubuntu-mono-nerd-font

# Install Brew cask personal packages.
brew install --cask betaflight-configurator
brew install --cask ledger-live
brew install --cask tor-browser

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

# Install FZF key bindings and completion.
$(brew --prefix)/opt/fzf/install

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

pip install dev-gpt
dev-gpt generate
dev-gpt configure --openai_api_key "$OPENAI_API_KEY"

# Install lehre. Required to generate JS docblocks in Vim (LJSDoc).
npm install --global lehre

# Install Typescript.
brew install ts-node
brew install typescript

# Install Bun.
npm install --global bun

# Other dev tools.
npm install --global fix-package-conflicts

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
nvim +'TSInstall! php' +qall
nvim +'TSInstall! phpdoc'
nvim +'TSInstall! regex' +qall
nvim +'TSInstall! scss' +qall
nvim +'TSInstall! typescript' +qall
nvim +'TSInstall! vim' +qall
nvim +'TSInstall! yaml' +qall
nvim +'TSUpdate all' +qall

# Setup Copilot.
nvim +'Copilot setup'

# Install Bun.
curl -fsSL https://bun.sh/install | bash
