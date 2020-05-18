#!/bin/sh
# shellcheck disable=SC2155

# Colourful manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Set to avoid `env` output from changing console colour
export LESS_TERMEND=$'\E[0m'

# Print field by number
field() {
  ruby -ane "puts \$F[$1]"
}

# Setup paths
remove_from_path() {
  [ -d "$1" ] || return
  PATHSUB=":$PATH:"
  PATHSUB=${PATHSUB//:$1:/:}
  PATHSUB=${PATHSUB#:}
  PATHSUB=${PATHSUB%:}
  export PATH="$PATHSUB"
}

add_to_path_start() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

add_to_path_end() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$PATH:$1"
}

force_add_to_path_start() {
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

quiet_which() {
  command -v "$1" >/dev/null
}

add_to_path_end "/usr/local/bin"
add_to_path_end "/usr/local/sbin"

add_to_path_end "$HOME/.dotfiles/bin"
add_to_path_end "$HOME/.gem/ruby/2.7.0/bin"

# Setup Go development
export GOPATH="$HOME"
add_to_path_end "$GOPATH/bin"

# Run rbenv if it exists
quiet_which rbenv && add_to_path_start "$(rbenv root)/shims"

# Aliases
alias mkdir="mkdir -vp"
alias df="df -H"
alias rm="rm -iv"
alias mv="mv -iv"
alias zmv="noglob zmv -vW"
alias cp="cp -irv"
alias du="du -sh"
alias make="nice make"
alias less="less --ignore-case --raw-control-chars"
alias rsync="rsync --partial --progress --human-readable --compress"
alias rake="noglob rake"
alias rg="rg --colors 'match:style:nobold' --colors 'path:style:nobold'"
alias be="noglob bundle exec"
alias sha256="shasum -a 256"

# Platform-specific stuff
if quiet_which brew
then
  export HOMEBREW_PREFIX="$(brew --prefix)"
  export HOMEBREW_REPOSITORY="$(brew --repo)"
  export HOMEBREW_AUTO_UPDATE_SECS=3600
  export HOMEBREW_BINTRAY_USER=mikemcquaid
  export HOMEBREW_DEVELOPER=1
  export HOMEBREW_BUNDLE_BREW_SKIP="rakudo-star mkcert nss aws-iam-authenticator docker docker-machine awscli awssume imagemagick kubectl@1.14 kustomize@2.0 container-diff"
  export HOMEBREW_BUNDLE_CASK_SKIP="github/bootstrap/zulu8"

  alias hbc='cd $HOMEBREW_REPOSITORY/Library/Taps/homebrew/homebrew-core'

  # Output whether the dependencies for a Homebrew package are bottled.
  brew_bottled_deps() {
    for DEP in "$@"; do
      echo "$DEP deps:"
      brew deps --include-build "$DEP" | xargs brew info | grep stable
      [ "$#" -ne 1 ] && echo
    done
  }

  # Output the most popular unbottled Homebrew packages
  brew_popular_unbottled() {
    brew deps --include-build --all |
      awk '{ gsub(":? ", "\n") } 1' |
      sort |
      uniq -c |
      sort |
      tail -n 500 |
      awk '{print $2}' |
      xargs brew info |
      grep stable |
      grep -v bottled
  }
fi

if [ "$MACOS" ]
then
  export GREP_OPTIONS="--color=auto"
  export CLICOLOR=1
  export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"
  export RESQUE_REDIS_URL="redis://localhost:6379"

  if quiet_which diff-highlight
  then
    # shellcheck disable=SC2016
    export GIT_PAGER='diff-highlight | less -+$LESS -RX'
  else
    # shellcheck disable=SC2016
    export GIT_PAGER='less -+$LESS -RX'
  fi

  if quiet_which exa
  then
    alias ls="exa -Fg"
  else
    alias ls="ls -F"
  fi

  add_to_path_end "$HOMEBREW_PREFIX/opt/git/share/git-core/contrib/diff-highlight"
  add_to_path_end "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

  alias fork="/Applications/Fork.app/Contents/Resources/fork_cli"
  alias vmrun="/Applications/VMware Fusion.app/Contents/Public/vmrun"

  alias locate="mdfind -name"
  alias finder-hide="setfile -a V"

  rbenv-nodenv-homebrew-sync
elif [ "$LINUX" ]
then
  quiet_which keychain && eval "$(keychain -q --eval --agents ssh id_rsa)"

  alias su="/bin/su -"
  alias ls="ls -F --color=auto"
  alias open="xdg-open"
elif [ "$WINDOWS" ]
then
  alias ls="ls -F --color=auto"

  open() {
    # shellcheck disable=SC2145
    cmd /C"$@"
  }
fi

# Setup asdf
source /usr/local/opt/asdf/asdf.sh

# Setup Perl
test -z "$PERL5LIB" && eval "$(perl -I~/perl5/lib/perl5 -Mlocal::lib)"

# Set up editor
if quiet_which nvim
then
  export EDITOR="nvim"
  export VISUAL="$EDITOR"
elif quiet_which code
then
  export EDITOR="code"
  export GIT_EDITOR="$EDITOR -w"
  export SVN_EDITOR="$GIT_EDITOR"
elif quiet_which vim
then
  export EDITOR="vim"
elif quiet_which vi
then
  export EDITOR="vi"
fi
alias e="$EDITOR"

HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ANALYTICS

# Run dircolors if it exists
quiet_which dircolors && eval "$(dircolors -b)"

# More colours with grc
# shellcheck disable=SC1090
[ -f "$HOMEBREW_PREFIX/etc/grc.bashrc" ] && source "$HOMEBREW_PREFIX/etc/grc.bashrc"

# Save directory changes
cd() {
  builtin cd "$@" || return
  [ "$TERMINALAPP" ] && command -v set_terminal_app_pwd >/dev/null \
    && set_terminal_app_pwd
  pwd > "$HOME/.lastpwd"
  ls
}

# Use ruby-prof to generate a call stack
ruby-call-stack() {
  ruby-prof --printer=call_stack --file=call_stack.html -- "$@"
}

# Pretty-print JSON files
json() {
  [ -n "$1" ] || return
  jsonlint "$1" | jq .
}

# Pretty-print Homebrew install receipts
receipt() {
  [ -n "$1" ] || return
  json "$HOMEBREW_PREFIX/opt/$1/INSTALL_RECEIPT.json"
}

# Move files to the Trash folder
trash() {
  mv "$@" "$HOME/.Trash/"
}

# GitHub API shortcut
github-api-curl() {
  noglob curl -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/$1"
}
