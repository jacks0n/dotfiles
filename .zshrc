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

# History.
setopt APPEND_HISTORY         # Sessions will append their history list to the history file, rather than replace it.
setopt EXTENDED_HISTORY       # Save each command's beginning Unix timestamp and the duration (in seconds) to the history file.
setopt HIST_IGNORE_ALL_DUPS   # Prevent duplicate history entries.
setopt HIST_VERIFY            # Require confirmation before executing a history substitution.
setopt HIST_IGNORE_SPACE      # Don't add commands beginning with a space to the history.
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks from each command line being added to the history list.
setopt INC_APPEND_HISTORY     # Incrementally add to the history file after each command, instead of until the shell exists.
setopt SHARE_HISTORY          # Share history between shell instances.

# Completion.
setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt AUTO_MENU            # Automatically use menu completion after the second consecutive request for completion.
setopt COMPLETE_ALIASES     # Enable completion for aliases. Enabling breaks completion with Fig.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
zstyle ':completion:*' completer _complete _expand _ignored _approximate
zstyle ':completion:*' list-dirs-first yes        # Show directories first.
zstyle ':completion:*' verbose yes                # Show descriptions for options.
zstyle ':completion:*' list-colors '=(#b) #([0-9]#)*=36=31' # Colour code completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # Enable case-insensitive completion.
zstyle ':completion:*' menu select                          # Enable menu-driven completion.
zstyle ':completion:*' special-dirs true                    # Complete . and .. special directories.
zstyle ':completion:*' squeeze-slashes true                 # Squeeze multiple slashes into one.
zstyle ':completion:*' expand prefix suffix                  # Expand variables in completion.
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR  # Set the completion caching directory.
zstyle ':completion::complete:*' use-cache 1                # Enable completion caching.
zstyle ':completion:*:approximate:*' max-errors 0 numeric   # Disable fuzzy/approximate completion.

# Other.
setopt AUTO_CD              # `cd` into directories.
setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB        # Treat the '#', '~' and '^' characters as part of patterns for filename generation, etc.
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells.
setopt NO_BEEP              # Beeps are annoying.
setopt NO_FLOW_CONTROL      # No c-s/c-q output freezing.
setopt PATH_DIRS            # Perform path search even on command names with slashes.
setopt PROMPT_SUBST         # Perform parameter expansion, command substitution and arithmetic expansion in prompts.

# Break at '/' on CTRL-W.
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Reduce Vim mode change to 0.1 seconds.
# How long to wait (in hundredths of a second) for additional characters in sequence.
export KEYTIMEOUT=1


##
# Key Bindings.
##

# Use Emacs bindings.
bindkey -e

##
# Package Settings.
##

# Pure.
export PURE_GIT_PULL=0 # Disable checking Git remote update status.

export FORGIT_NO_ALIASES=1


##
# zinit packages.
##

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
if [ ! -d "$ZSH_CACHE_DIR" ] ; then
  mkdir -p "$ZSH_CACHE_DIR"
fi

if [[ ! -d "$ZINIT_HOME" ]] ; then
  echo '=> Installing zinit'
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

autoload -Uz compinit
compinit -C
# Set HOMEBREW_PREFIX for later use (use cached value from .shrc if available)
export HOMEBREW_PREFIX="${CACHED_BREW_PREFIX:-$(brew --prefix)}"

zinit load 'mafredri/zsh-async'
zinit ice pick'async.zsh' src'pure.zsh'; zinit light 'sindresorhus/pure'
zinit load 'djui/alias-tips'
if hash conda > /dev/null 2>&1 ; then
  zinit load 'conda-incubator/conda-zsh-completion'
fi
if hash jupyter > /dev/null 2>&1 ; then
  zinit load 'jupyter/jupyter_core'
fi
zinit load 'wfxr/forgit'
zinit load 'b4b4r07/cli-finder'
zinit load 'zsh-users/zsh-completions'
zinit ice wait'1' lucid; zinit light 'lukechilds/zsh-better-npm-completion'
zinit load 'changyuheng/fz'
zinit load 'rupa/z'
zinit light 'zsh-users/zsh-autosuggestions'
zinit load 'docker/cli'
zinit load 'docker/compose'
zinit light 'zdharma-continuum/fast-syntax-highlighting'
zinit light 'zsh-users/zsh-history-substring-search'
zinit load 'hlissner/zsh-autopair'
zinit load 'darvid/zsh-poetry'

zinit ice haspoetry id-as'poetry---zsh-completions' as'completion' \
  wait silent blockf nocompile \
  atclone'poetry completions zsh >! _poetry' \
  atpull'%atclone' run-atpull \
  atinit'zinit cdreplay -q' \
  pick'_poetry'

if [[ $TERM_PROGRAM == 'iTerm.app' ]] ; then
  zinit snippet OMZ::plugins/iterm2/iterm2.plugin.zsh
fi
if hash saml2aws 2>/dev/null ; then
  eval "$(saml2aws --completion-script-zsh)"
fi

# AWS CLI completion
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
autoload bashcompinit && bashcompinit
complete -C "$CACHED_BREW_PREFIX/bin/aws_completer" aws

# zsh-syntax-highlighting.
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets cursor)

# zsh-history-substring-search.
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

##
# Autoloads.
##

autoload zmv


##
# Shell Includes.
##

source "$HOME/.shrc"
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"


##
# 3rd Party.
##

# Ensure Python virtual environment always has PATH priority.
if [[ -n "$VIRTUAL_ENV" ]]; then
  PATH="${PATH//$VIRTUAL_ENV\/bin:/}"
  PATH="$VIRTUAL_ENV/bin:$PATH"
  export PATH
fi

zinit ice wait'2' lucid id-as'pip-completion' as'null' \
  atload'eval "$(pip completion --zsh)"; compctl -K _pip_completion pip3'
zinit light zdharma-continuum/null

# bun completion.
if [[ -s "$HOME/.bun/_bun" ]] ; then
  source "$HOME/.bun/_bun"
fi

if command -v fzf &> /dev/null; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

export PATH="/Users/jackson/.codeium/windsurf/bin:$PATH"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
