#!/usr/bin/env bash

export DOTFILES_PATH=~/.dotfiles

echo "=> Fetching latest dotfiles"
git_status="$(git status -s 2>&1)"
if [[ -n "$git_status" && "$1" != "--local" ]] ; then
    echo "ERR: Unsaved changes"
    echo "$git_status"
    exit 1
fi

if [[ "$1" != "--local" ]] ; then
	git fetch
	git pull
fi

echo "=> Deleting existing dotfiles"
rm ~/.aliases 2>/dev/null
rm ~/.curlrc 2>/dev/null
rm ~/.functions 2>/dev/null
rm ~/.gitconfig 2>/dev/null
rm ~/.gitconfig_system 2>/dev/null
rm ~/.gitconfig_user 2>/dev/null
rm ~/.osx 2>/dev/null
rm ~/.zshrc 2>/dev/null
rm ~/.zshrc 2>/dev/null
rm ~/.iterm2_shell_integration.zsh 2>/dev/null

echo "=> Linking dotfiles"
ln -s --force "$DOTFILES_PATH/.aliases" ~/.aliases
ln -s --force "$DOTFILES_PATH/.curlrc" ~/.curlrc
ln -s --force "$DOTFILES_PATH/.functions" ~/.functions
ln -s --force "$DOTFILES_PATH/.gitconfig" ~/.gitconfig
ln -s --force "$DOTFILES_PATH/.gitconfig_system" ~/.gitconfig_system
ln -s --force "$DOTFILES_PATH/.gitconfig_user" ~/.gitconfig_user
ln -s --force "$DOTFILES_PATH/.osx" ~/.osx
ln -s --force "$DOTFILES_PATH/.zshrc" ~/.zshrc
ln -s --force "$DOTFILES_PATH/vendor/.iterm2_shell_integration.zsh" ~/.iterm2_shell_integration.zsh

echo "=> Re-loading ~/.zshrc"
source ~/.zshrc