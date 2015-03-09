# Not a tty
[ -z "$PS1" ] && return


##
#  Zsh
##

# Number of lines of history kept within the shell
HISTSIZE=10000
# File where history is saved
HISTFILE="$HOME/.zsh_history"
# Number of lines of history to save to $HISTFILE
SAVEHIST=10000

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a succesive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

# Use caching to make completion for commands quicker.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcache"

# Case-insensitive (all), partial-word, and then substring completion.
if zstyle -t ':omz:completion:*' case-sensitive; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  setopt CASE_GLOB
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unsetopt CASE_GLOB
fi

# Enable menu for `kill`
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Enable menu for `man`
zstyle ':completion:*:*:man:*' menu yes select


##
#  Oh My Zsh
##

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Located in ~/.oh-my-zsh/themes/, can also use "random".
ZSH_THEME='robbyrussell'

# Case-sensitive completion.
CASE_SENSITIVE='false'

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS='true'

# Disable marking untracked files under VCS as dirty, much faster for large repositories.
DISABLE_UNTRACKED_FILES_DIRTY='true'

# Plugins to load (plugins can be found in ~/.oh-my-zsh/plugins/*).
plugins=(catimg git brew npm pip python gnu-utils history-substring-search zsh-syntax-highlighting)

# Fish-like live syntax highlighting 
# SEE: https://github.com/zsh-users/zsh-syntax-highlighting/tree/master/highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

source "$ZSH/oh-my-zsh.sh"

# Depricated, still used in .oh-my-zsh/lib/grep.zsh
unset GREP_OPTIONS



##
#  Global variables - $PATH, $MANPATH, $EDITOR, $VISUAL, etc.
##

# Preferred editor for local and remote sessions
export EDITOR='vim'
export VISUAL='mvim'

# Homebrew base
PATH="$(brew --prefix)/sbin:$PATH"
PATH="$(brew --prefix)/bin:$PATH"
MANPATH="$(brew --prefix)/man:$MANPATH"
MANPATH="$(brew --prefix)/share/man:$MANPATH"

# Homebrew Cask - set default install directory to /Applications not ~/Applications
export HOMEBREW_CASK_OPTS="--appdir='/Applications' --prefpanedir='/Library/PreferencePanes' --qlplugindir='/Library/QuickLook' --widgetdir='/Library/Widgets' --fontdir='/Library/Fonts' --input_methoddir='/Library/Input Methods' --screen_saverdir='/Library/Screen Savers'"

# Homebrew GNU coreutils, sed & tar
PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
MANPATH="$(brew --prefix)/opt/coreutils/libexec/gnuman:$MANPATH"
MANPATH="$(brew --prefix)/opt/gnu-sed/libexec/gnuman:$MANPATH"

# Homebrew PHP
# PATH="$(brew --prefix php56)/bin:$PATH"

# Node.js
NODE_PATH="$(brew --prefix)/lib/node_modules"
NODE_PATH="$(brew --prefix)/share/npm/lib/node_modules:$NODE_PATH"
PATH="$(brew --prefix)/share/npm/bin:$PATH"

# Android emulator / SDK
export ANDROID_HOME='/usr/local/opt/android-sdk'

# ~/bin directory
PATH="$HOME/bin:$PATH"

# Golang
export GOPATH="$HOME/bin/go"
export GOROOT="$(go env GOROOT)"

# ansiweather: https://github.com/fcambus/ansiweather
if [ -x "$HOME/bin/ansiweather" ] ; then
    PATH="$HOME/bin/ansiweather:$PATH"
    alias weather="$HOME/bin/ansiweather/ansiweather"
fi

# Expose $PATH & $MANPATH to forked shells
export PATH
export MANPATH


##
#  Includes
##

source "$HOME/.aliases"
source "$HOME/.functions"

# GRC colorizes nifty unix tools all over the place
source "$(brew --prefix)/etc/grc.bashrc"


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


##
#  Miscellaneous
##

# z - https://github.com/rupa/z
source "$(brew --prefix)/etc/profile.d/z.sh"

# fzf - https://github.com/junegunn/fzf
source "$HOME/.fzf.zsh"

# Surpress Wine debugging info
WINEDEBUG=
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
