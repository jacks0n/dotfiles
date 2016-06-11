# Not a tty.
[ -z "$PS1" ] && return


##
#  Zsh
##

# Number of lines of history kept within the shell.
HISTSIZE=10000
# File where history is saved.
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

# Enable menu for `kill`.
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Enable menu for `man`.
zstyle ':completion:*:*:man:*' menu yes select


##
#  Oh My Zsh.
##

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Located in ~/.oh-my-zsh/themes/, can also use "random".
# agnoster, miloshadzic, bullet-train, schminitz
# ZSH_THEME='random'

# Case-sensitive completion.
CASE_SENSITIVE='false'

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS='false'

# Disable marking untracked files under VCS as dirty, much faster for large repositories.
DISABLE_UNTRACKED_FILES_DIRTY='true'

# Zsh completions from brew.
fpath=(
  /usr/local/share/zsh-completions
  /usr/local/share/zsh/site-functions
  $fpath
)

# source "$HOME/.oh-my-zsh/oh-my-zsh.sh"


##
#  Custom Includes.
##

[ -f "$HOME/.proxy"      ] && source "$HOME/.proxy"
[ -f "$HOME/.aliases"    ] && source "$HOME/.aliases"
[ -f "$HOME/.functions"  ] && source "$HOME/.functions"
[ -f "$HOME/.shrc.local" ] && source "$HOME/.shrc.local"


##
#  3rd-party.
##

# GRC colorizes nifty unix tools all over the place
[ -f '/usr/local/etc/grc.bashrc' ] && source '/usr/local/etc/grc.bashrc'

# z - https://github.com/rupa/z
[ -f '/usr/local/etc/profile.d/z.sh' ] && source '/usr/local/etc/profile.d/z.sh'

# fzf - https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Antigen.
if [ -f "$(brew --prefix)/share/antigen.zsh" ] ; then
  # Fish-like live syntax highlighting.
  # SEE: https://github.com/zsh-users/zsh-syntax-highlighting/tree/master/highlighters
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

  source "$(brew --prefix)/share/antigen.zsh"

  antigen use oh-my-zsh

  antigen bundle brew
  antigen bundle git
  antigen bundle gnu-utils
  antigen bundle history-substring-search
  antigen bundle npm
  antigen bundle pip
  antigen bundle python

  # antigen theme robbyrussell
  # antigen theme oskarkrawczyk/honukai-iterm-zsh honukai
  # antigen theme wezm
  antigen bundle mafredri/zsh-async
  antigen bundle sindresorhus/pure

  antigen apply
fi

# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh



##
#  Colour Tweaks.
##

# Add colours to man pages.
man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
  LESS_TERMCAP_md=$'\E[01;38;5;74m' \
  LESS_TERMCAP_me=$'\E[0m' \
  LESS_TERMCAP_se=$'\E[0m' \
  LESS_TERMCAP_so=$'\E[38;5;246m' \
  LESS_TERMCAP_ue=$'\E[0m' \
  LESS_TERMCAP_us=$'\E[04;38;5;146m' \
  man $@
}


##
# Run on Startup.
#

cowjoke
