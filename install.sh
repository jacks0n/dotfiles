#!/usr/bin/env bash

# Install Brew.
if [[ ! type "$1" &>/dev/null ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Brew packages.
brew install bash
brew install bash-completion
brew install bat
brew install brew-cask-completion
brew install ccat
brew install cmake # Required for YouCompleteMe.
brew install composer
brew install coreutils
brew install cowsay
brew install curl
brew install diff-so-fancy
brew install docker-compose
brew install editorconfig
brew install fd
brew install fzf
brew install git
brew install gnu-sed
brew install gnu-tar
brew install grep
brew install hashicorp/tap/terraform-ls
brew install homebrew/cask-fonts/font-anonymice-powerline
brew install homebrew/cask-fonts/font-dejavu-sans-mono-for-powerline
brew install homebrew/cask-fonts/font-droid-sans-mono-for-powerline
brew install homebrew/cask-fonts/font-fantasque-sans-mono
brew install homebrew/cask-fonts/font-fira-code
brew install homebrew/cask-fonts/font-fira-mono-for-powerline
brew install homebrew/cask-fonts/font-fira-sans
brew install homebrew/cask-fonts/font-hack
brew install homebrew/cask-fonts/font-inconsolata-dz-for-powerline
brew install homebrew/cask-fonts/font-inconsolata-for-powerline
brew install homebrew/cask-fonts/font-inconsolata-g-for-powerline
brew install homebrew/cask-fonts/font-input
brew install homebrew/cask-fonts/font-liberation-mono-for-powerline
brew install homebrew/cask-fonts/font-menlo-for-powerline
brew install homebrew/cask-fonts/font-merienda
brew install homebrew/cask-fonts/font-merienda-one
brew install homebrew/cask-fonts/font-merriweather
brew install homebrew/cask-fonts/font-meslo-for-powerline
brew install homebrew/cask-fonts/font-meslo-lg
brew install homebrew/cask-fonts/font-monofur-for-powerline
brew install homebrew/cask-fonts/font-monoid
brew install homebrew/cask-fonts/font-office-code-pro
brew install homebrew/cask-fonts/font-oxygen
brew install homebrew/cask-fonts/font-oxygen-mono
brew install homebrew/cask-fonts/font-pt-mono
brew install homebrew/cask-fonts/font-source-sans-pro
brew install homebrew/cask-fonts/font-ubuntu
brew install homebrew/cask-fonts/font-ubuntu-mono-derivative-powerline
brew install htop
brew install jq
brew install lolcat
brew install neovim
brew install netcat
brew install node
brew install nvm
brew install php
brew install python
brew install ranger
brew install ripgrep
brew install rsync
brew install shellcheck
brew install sqlite
brew install svn
brew install the_silver_searcher
brew install tmux
brew install tree
brew install tree-sitter
brew install unar
brew install universal-ctags
brew install unzip
brew install vim
brew install watchman
brew install wget
brew install whois
brew install yarn
brew install z
brew install zsh-autosuggestions

# Install Brew cask packages.
brew install --cask alfred
brew install --cask dash
brew install --cask dropbox
brew install --cask evernote
brew install --cask firefox
brew install --cask font-hack-nerd-font
brew install --cask homebrew/cask/docker
brew install --cask insomnia
brew install --cask iterm2
brew install --cask lastpass
brew install --cask macvim
brew install --cask microsoft-teams
brew install --cask postman
brew install --cask sequel-pro
brew install --cask slack
brew install --cask sourcetree
brew install --cask spectacle
brew install --cask spotify
brew install --cask vimr
brew install --cask vlc

# Language servers.
npm install -g bash-language-server
npm install -g sql-language-server
npm install -g dockerfile-language-server-nodejs
npm install -g graphql-language-service-cli
npm install -g @serverless-ide/language-server

# Install latest Node version for NVM.
nvm install --lts

# Install Neovim libraries.
pip3 install pynvim --upgrade
npm install -g neovim

# Install coc.nvim plugins.
nvim +'CocInstall -sync coc-css' +qall
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
nvim +'TSInstall phpdoc' # Mac ARM not supported yet. https://github.com/claytonrcarter/tree-sitter-phpdoc/issues/15
nvim +'TSInstall scss' +qall
nvim +'TSInstall typescript' +qall
nvim +'TSInstall vim' +qall
nvim +'TSInstall yaml' +qall
nvim +'TSUpdate all' +qall
