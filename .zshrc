# Not a tty
[ -z "$PS1" ] && return


##
#  Zsh
##

# Number of lines of history kept within the shell
HISTSIZE=10000
# File where history is saved
HISTFILE="~/.zsh_history"
# Number of lines of history to save to $HISTFILE
SAVEHIST=10000

# Disable vi-mode when searching history
bindkey '^R' history-incremental-search-backward



##
#  Oh My Zsh
##

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Case-sensitive completion.
CASE_SENSITIVE="false"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty.
# This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew npm pip python sublime urltools web-search gnu-utils history-substring-search zsh-syntax-highlighting dircycle)
source "$ZSH/oh-my-zsh.sh"



##
#  $PATH, $EDITOR and $VISUAL exports
##

# Node.js
export NODE_PATH="$(brew --prefix)/lib/node_modules:$(brew --prefix)/share/npm/lib/node_modules:$NODE_PATH"
export PATH="$(brew --prefix)/share/npm/bin:$PATH"

# Homebrew
export PATH="$(brew --prefix)/sbin:$PATH"
export PATH="$(brew --prefix)/bin:$PATH"
export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"

# ~/Scripts directory
[ -d ~/bin ] && export PATH="$HOME/bin:$PATH"

# MAMP's binaries - mysql, mysqldump, etc.
[ -d "/Applications/MAMP/Library/bin" ] && export PATH="/Applications/MAMP/Library/bin:$PATH"

# Extra man pages
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# Golang
export PATH="/usr/local/opt/go/libexec/bin:$PATH"



##
#  Includes
##

[ -f ~/.functions ] && source ~/.functions
[ -f ~/.aliases ] && source ~/.aliases

# GRC colorizes nifty unix tools all over the place
# [ -f "$(brew --prefix)/etc/grc.bashrc" ] &&  source "$(brew --prefix)/etc/grc.bashrc"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR="subl"
else
    export EDITOR="vim"
fi
export VISUAL="subl"


# iTerm 2 shell integration
#
[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh


##
#  OS X Unicode fix
##

export LC_CTYPE=C
export LANG=C
export LC_ALL=C



##
#  Colour tweaks
##

# Add colours to man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}