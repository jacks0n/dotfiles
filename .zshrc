# Not a tty.
[ -z "$PS1" ] && return


##
# Zsh
##

# Number of lines of history kept within the shell.
HISTSIZE=10000

# File where history is saved.
HISTFILE="$HOME/.zsh_history"

# Number of lines of history to save to $HISTFILE
SAVEHIST=10000

setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.
setopt APPEND_HISTORY       # Sessions will append their history list to the history file, rather than replace it.
setopt AUTO_CD              # `cd` into directories.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt AUTO_MENU            # Automatically use menu completion after the second consecutive request for completion.
setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt EXTENDED_GLOB        # Treat the '#', '~' and '^' characters as part of patterns for filename generation, etc.
setopt EXTENDED_HISTORY     # Save each command's beginning Unix timestamp and the duration (in seconds) to the history file.
setopt HIST_IGNORE_ALL_DUPS # Prevent duplicate history items.
setopt HIST_IGNORE_SPACE    # Don't add commands beginning with a space to the history.
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks from each command line being added to the history list.
setopt INC_APPEND_HISTORY   # Incrementally add to the history file after each command, instead of until the shell exists.
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells.
setopt NO_BEEP              # Beeps are annoying.
setopt NO_FLOW_CONTROL      # No c-s/c-q output freezing.
setopt PATH_DIRS            # Perform path search even on command names with slashes.
setopt PROMPT_SUBST         # Perform parameter expansion, command substitution and arithmetic expansion in prompts.
setopt SHARE_HISTORY        # Share history between shell instances.
setopt COMPLETE_ALIASES     # Enable completion for aliases.

zstyle ':completion:*' list-colors '=(#b) #([0-9]#)*=36=31' # Colour code completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # Enable case-insensitive completion.
zstyle ':completion:*' menu select                          # Enable menu-driven completion.
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR  # Set the completion caching directory.
zstyle ':completion::complete:*' use-cache 1                # Enable completion caching.

# Reduce Vim mode change to 0.1 seconds.
# How long to wait (in hundredths of a second) for additional characters in sequence.
export KEYTIMEOUT=1


##
# zplug.
##

export ZPLUG_HOME="$HOME/.zplug"

# Install zplug if it's not installed.
if [ ! -f "$ZPLUG_HOME/init.zsh" ] ; then
  echo '=> Installing zplug'
  mkdir "$ZPLUG_HOME"
  git clone https://github.com/zplug/zplug "$ZPLUG_HOME"
fi

source "$ZPLUG_HOME/init.zsh"

# zplug 'plugins/pip', from:oh-my-zsh, ignore:oh-my-zsh.sh
# zplug 'plugins/npm', from:oh-my-zsh, ignore:oh-my-zsh.sh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'mafredri/zsh-async', on:sindresorhus/pure
zplug 'sindresorhus/pure'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug 'zsh-users/zsh-history-substring-search', defer:3
zplug 'plugins/phing', from:oh-my-zsh

# Install missing plugins.
zplug check || zplug install

zplug load


##
# Package Settings.
##

# Pure.
export PURE_GIT_PULL=0 # Disable checking Git remote update status.

# zsh-syntax-highlighting.
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)

# zsh-history-substring-search.
zmodload zsh/terminfo
if [[ "$TERM_PROGRAM" == 'iTerm.app' ]] ; then
  bindkey "$terminfo[cuu1]" history-substring-search-up
  bindkey "$terminfo[cud1]" history-substring-search-down
else
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
fi


##
# Shell Includes.
##

source "$HOME/.shrc"


##
# Other.
##

# Alias Symfony completions to `sc`.
compdef sc=console


##
# 3rd Party.
##

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
