#!/usr/bin/env bash
# Shared helpers for install.sh / setup.sh. Meant to be sourced, not executed.
#
# Everything here is portable across bash and zsh (old or new), so it's safe
# whether the scripts run via their shebang or get pasted into an interactive
# shell. Note `read -p` means "read from coprocess" in zsh, so we print prompts
# with printf and read keys with `read -n` (bash) / `read -k` (zsh).

# Read a single keypress into $REPLY, printing $1 as the prompt first.
prompt_key() {
  printf '%s' "$1"
  if [ -n "$ZSH_VERSION" ]; then
    read -k 1 -r REPLY
  else
    read -n 1 -r REPLY
  fi
  echo
}

# Yes/no prompt defaulting to YES. Returns 0 unless the answer starts with n/N.
prompt_yes() {
  prompt_key "$1 [Y/n]: "
  [[ ! $REPLY =~ ^[Nn]$ ]]
}

# Yes/no prompt defaulting to NO. Returns 0 only if the answer starts with y/Y.
prompt_no() {
  prompt_key "$1 [y/N]: "
  [[ $REPLY =~ ^[Yy]$ ]]
}

# Read a full line into the variable named by $2 (default REPLY), prompting $1.
prompt_line() {
  printf '%s' "$1"
  read -r "${2:-REPLY}"
}
