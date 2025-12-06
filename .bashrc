# Case insentivie completion.
set completion-ignore-case on


##
# Shell Includes.
##

source "$HOME/.shrc"


##
# 3rd Party.
##

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f $HOME/.config/cani/completions/_cani.bash ] && source $HOME/.config/cani/completions/_cani.bash

# mise - polyglot version manager
eval "$(mise activate bash)"
. "$HOME/.cargo/env"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"
