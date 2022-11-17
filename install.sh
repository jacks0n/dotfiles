#!/usr/bin/env bash

# Install Brew.
if [[ ! type "$1" &>/dev/null ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Brew packages.
brew install awscli
brew install bash
brew install bash-completion
brew install bat
brew install betterzip
brew install bfg
brew install brave-browser
brew install brew-cask-completion
brew install ccat
brew install cmake # Required for YouCompleteMe.
brew install colordiff
brew install composer
brew install coreutils
brew install cowsay
brew install curl
brew install diffr
brew install docker-compose
brew install edgedb/tap/edgedb-cli
brew install editorconfig
brew install elcolorcode
brew install exa
brew install fd
brew install findutils
brew install fx
brew install fzf
brew install gawk
brew install gh
brew install git
brew install git-delta
brew install gnu-sed
brew install gnu-tar
brew install go # Required for SQL language server.
brew install grep
brew install hashicorp/tap/terraform-ls
brew install homebrew/cask-fonts/font-droid-sans-mono-nerd-font
brew install homebrew/cask-fonts/font-fantasque-sans-mono-nerd-font
brew install homebrew/cask-fonts/font-fira-mono-nerd-font
brew install homebrew/cask-fonts/font-hack-nerd-font
brew install homebrew/cask-fonts/font-inconsolata-nerd-font
brew install homebrew/cask-fonts/font-jetbrains-mono-nerd-font
brew install homebrew/cask-fonts/font-liberation-mono-for-powerline
brew install homebrew/cask-fonts/font-mononoki-nerd-font
brew install homebrew/cask-fonts/font-ubuntu-mono-nerd-font
brew install htop
brew install jesseduffield/lazygit/lazygit
brew install jq
brew install lolcat
brew install ms-jpq/sad/sad
brew install neovim
brew install netcat
brew install nnn
brew install node
brew install nvm
brew install openapi-generator
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
brew install svn
brew install the_silver_searcher
brew install tig
brew install tmux
brew install tree
brew install tree-sitter
brew install unar
brew install universal-ctags
brew install unzip
brew install vim
brew install viu
brew install watchman
brew install webtorrent
brew install wget
brew install whois
brew install yarn
brew install z
brew install zsh
brew install zsh-autosuggestions
brew tap buo/cask-upgrade

# Setup Java.
sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
# @todo Add to ~/.shrc.local
# export JAVA_HOME="$(brew --prefix openjdk@11)/libexec/openjdk.jdk/Contents/Home"

# Install Quick Look plugins.
brew install --cask apparency                        # Preview the contents of a macOS app.
brew install --cask qlcolorcode                      # Preview source code files with syntax highlighting.
brew install --cask qlimagesize                      # Display image size and resolution.
brew install --cask qlmarkdown                       # Preview Markdown files.
brew install --cask qlstephen                        # Preview plain text files without or with unknown file extension.
brew install --cask qlvideo                          # Preview most types of video files, as well as their thumbnails, cover art and metadata.
brew install --cask quicklook-json                   # Preview JSON files.
brew install --cask quicklookase                     # Preview Adobe ASE Color Swatches.
brew install --cask suspicious-package               # Preview the contents of a standard Apple installer package.
brew install --cask quicklookapk                     # Preview Android APK files.
brew install --cask quicklook-pat                    # Preview Adobe Photoshop pattern files.
brew install --cask --no-quarantine syntax-highlight # Preview many different source code files.
brew install --cask qladdict                         # Preview subtitle (.srt) files.
sudo xattr -rd com.apple.quarantine /Library/QuickLook

# Install Brew cask packages.
brew install --cask 1password
brew install --cask postman
brew install --cask alfred
brew install --cask arq
brew install --cask bartender
brew install --cask beekeeper-studio
brew install --cask catch
brew install --cask dash
brew install --cask drawio
brew install --cask dropbox
brew install --cask evernote
brew install --cask fig
brew install --cask firefox
brew install --cask font-sf-mono-nerd-font
brew install --cask google-drive
brew install --cask google-chrome
brew install --cask homebrew/cask/docker
brew install --cask hyper
brew install --cask insomnia
brew install --cask istat-menus
brew install --cask iterm2
brew install --cask lastpass
brew install --cask macvim
brew install --cask masscode
brew install --cask microsoft-teams
brew install --cask notion
brew install --cask oracle-jdk
brew install --cask postman
brew install --cask sequel-pro
brew install --cask sourcetree
brew install --cask spectacle
brew install --cask spotify
brew install --cask tabby
brew install --cask telegram-desktop
brew install --cask todoist
brew install --cask vimr
brew install --cask vlc
brew install --cask zettlr

# Install Brew cask work packages.
brew install --cask slack

# Install Brew cask personal packages.
brew install --cask ledger-live
brew install --cask tor-browser
brew install --cask backblaze

# Language servers.
npm install --global @serverless-ide/language-server
npm install --global diagnostic-languageserver

# Linters.
npm install --global stylelint
npm install --global prettier
npm install --global eslint
composer global require 'squizlabs/php_codesniffer=*'
pip3 install vim-vint --upgrade

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
nvim +'LspInstall --sync sumneko_lua' +qll
nvim +'LspInstall --sync terraformls' +qall
nvim +'LspInstall --sync tflint' +qall
nvim +'LspInstall --sync tsserver' +qall
nvim +'LspInstall --sync vimls' +qall
nvim +'LspInstall --sync yamlls' +qall

# Install latest Node version for NVM.
nvm install --lts

# Install Neovim libraries.
pip3 install pynvim --upgrade
npm install --global neovim

# Install lehre. Required to generate JS docblocks in Vim (LJSDoc).
npm install --global lehre

# Install Typescript.
npm install --global typescript
npm install --global ts-node

# Instant Markdown.
npm --global install instant-markdown-d

# Install coc.nvim plugins.
nvim -c +'CocInstall -sync coc-css' +qall
nvim +'CocInstall -sync coc-dictionary' +qall
nvim +'CocInstall -sync coc-docker' +qall
nvim +'CocInstall -sync coc-eslint' +qall
nvim +'CocInstall -sync coc-fzf-preview' +qall
nvim +'CocInstall -sync coc-html' +qall
nvim +'CocInstall -sync coc-json' +qall
nvim +'CocInstall -sync coc-markdownlint' +qall
nvim +'CocInstall -sync coc-omni' +qall
nvim +'CocInstall -sync coc-phpactor' +qall
nvim +'CocInstall -sync coc-phpls' +qall
nvim +'CocInstall -sync coc-pyright' +qall
nvim +'CocInstall -sync coc-sh' +qall
nvim +'CocInstall -sync coc-syntax' +qall
nvim +'CocInstall -sync coc-tabnine' +qall
nvim +'CocInstall -sync coc-tag' +qall
nvim +'CocInstall -sync coc-tsserver' +qall
nvim +'CocInstall -sync coc-vimlsp' +qall
nvim +'CocInstall -sync coc-word' +qall
nvim +'CocInstall -sync coc-yaml' +qall
nvim +CocUpdateSync +qall

# Install Treesitter plugins.
nvim +'TSInstall bash' +qall
nvim +'TSInstall comment' +qall
nvim +'TSInstall css' +qall
nvim +'TSInstall graphql' +qall
nvim +'TSInstall help' +qall
nvim +'TSInstall html' +qall
nvim +'TSInstall http' +qall
nvim +'TSInstall javascript' +qall
nvim +'TSInstall jsdoc' +qall
nvim +'TSInstall json' +qall
nvim +'TSInstall json5' +qall
nvim +'TSInstall jsonc' +qall
nvim +'TSInstall php' +qall
# Mac ARM not yet supported yet. https://github.com/claytonrcarter/tree-sitter-phpdoc/issues/15
if [[ $(uname -m) !== 'arm' ]] ; then
  nvim +'TSInstall phpdoc'
fi
nvim +'TSInstall scss' +qall
nvim +'TSInstall typescript' +qall
nvim +'TSInstall vim' +qall
nvim +'TSInstall yaml' +qall
nvim +'TSUpdate all' +qall

# Setup Copilot.
nvim +'Copilot setup'
