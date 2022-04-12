#!/usr/bin/env bash

export DOTFILES_PATH=~/.dotfiles

home_dotfiles=(
  ~/.aliases
  ~/.bashrc
  ~/.ctags
  ~/.editorconfig
  ~/.curlrc
  ~/.exports
  ~/.functions
  ~/.gitconfig
  ~/.npmrc
  ~/.shrc
  ~/.spacemacs
  ~/.osx
  ~/.tmux.conf
  ~/.inputrc
  ~/.vim
  ~/.vimrc
  ~/.wgetrc
  ~/.sshrc
  ~/.hushlogin
  ~/.zshrc
  ~/.zshenv
  ~/.iterm2_shell_integration.zsh
)

# Delete existing dotfiles.
for home_dotfile in ${home_dotfiles[@]} ; do
  basename="$(basename "$home_dotfile")"
  home_dotfile_path="$HOME/$basename"
  if [[ -f "$home_dotfile_path" || -L "$home_dotfile_path" ]] ; then
    echo "=> Deleting '$home_dotfile_path"
    rm -f "$home_dotfile_path"
  fi
done

# Check if any dotfile already exists.
for dotfile_path in ${dotfile_paths[@]} ; do
  basename="$(basename "$dotfile_path")"
  dotfile_home_path="$HOME/$basename"
  if [[ -f "$dotfile_home_path" || -L "$dotfile_home_path" ]] ; then
    echo >&2 "ERROR: '$dotfile_home_path' already exists"
    exit 1
  fi
done

echo '=> Linking dotfiles'
for dotfile_path in ${home_dotfiles[@]} ; do
  basename="$(basename "$dotfile_path")"
  echo "Linking '$DOTFILES_PATH/$basename' -> '~/$basename'"
  ln -s "$DOTFILES_PATH/$basename" ~/$basename
done

# Setup Neovim.
ln -s ~/.vim ~/.config/nvim

# Intelephense license.
mkdir -p ~/intelephense
read -e -p 'Intelephense license: ' intelephense_license
echo "$intelephense_license" > ~/intelephense/license.txt

echo '=> Re-loading ~/.zshrc'
source ~/.zshrc
