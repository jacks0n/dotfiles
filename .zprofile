##
#  Global variables - $PATH, $MANPATH, $EDITOR, $VISUAL, etc.
##

# Preferred editor for local and remote sessions.
export EDITOR='vim'
export VISUAL='subl'

# Homebrew paths.
export PATH="$(brew --prefix)/sbin:$PATH"
export PATH="$(brew --prefix)/bin:$PATH"
export MANPATH="$(brew --prefix)/man:$MANPATH"
export MANPATH="$(brew --prefix)/share/man:$MANPATH"

# Homebrew Cask path preferences.
export HOMEBREW_CASK_OPTS="--appdir=/Applications --prefpanedir=/Library/PreferencePanes --qlplugindir=/Library/QuickLook --colorpickerdir=/Library/ColorPickers --fontdir=/Library/Fonts --input_methoddir='/Library/Input Methods' --screen_saverdir='/Library/Screen Savers' --servicedir=/Library/Services"

# Homebrew GNU coreutils, sed & tar.
export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
export MANPATH="$(brew --prefix)/opt/coreutils/libexec/gnuman:$MANPATH"
export MANPATH="$(brew --prefix)/opt/gnu-sed/libexec/gnuman:$MANPATH"

# Node.js
export NODE_PATH="$(brew --prefix)/lib/node_modules"
export NODE_PATH="$(brew --prefix)/share/npm/lib/node_modules:$NODE_PATH"
export PATH="$(brew --prefix)/share/npm/bin:$PATH"

# Android emulator / SDK.
export ANDROID_HOME='/usr/local/opt/android-sdk'

# User ~/bin directories.
export PATH="$HOME/bin:$PATH"

# FCL flow.
export PATH="$HOME/flow:$PATH"

# Composer.
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Ruby.
# export GEM_PATH="$(gem env gempath):$GEM_PATH"
# export GEM_PATH="/Library/Ruby/Site/2.0.0/rubygems:/Library/Ruby/Gems/2.0.0/gems:$GEM_PATH"

# Golang.
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export GOROOT="$(go env GOROOT)"

# NeoVim
export NVIM_TUI_ENABLE_TRUE_COLOR=1

# Depricated, still used in .oh-my-zsh/lib/grep.zsh
unset GREP_OPTIONS

#  OS X Unicode fix.
# export LC_CTYPE=C
# export LANG=C.UTF-8
# export LC_ALL=C.UTF-8

# Surpress Wine debugging info.
export WINEDEBUG=

