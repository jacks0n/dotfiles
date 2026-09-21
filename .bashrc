# Case insentivie completion.
set completion-ignore-case on


##
# Shell Includes.
##

source "$HOME/.shrc"


##
# 3rd Party.
##

# mise - polyglot version manager (node, python, etc.)
eval "$(mise activate bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f $HOME/.config/cani/completions/_cani.bash ] && source $HOME/.config/cani/completions/_cani.bash

# Only present when Rust is installed via rustup-init (not Homebrew rustup).
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
