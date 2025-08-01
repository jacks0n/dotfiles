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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"
