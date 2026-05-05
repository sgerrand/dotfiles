# shellcheck shell=bash

# 077 would be more secure, but 022 is more useful.
umask 022

# Save more history
export HISTSIZE="100000"
export SAVEHIST="100000"

# OS variables
[ "$(uname -s)" = "Darwin" ] && export MACOS=1 && export UNIX=1
[ "$(uname -s)" = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1
grep -q "Microsoft" /proc/version 2>/dev/null && export UBUNTU_ON_WINDOWS=1

# Fix systems missing $USER
if [ -z "$USER" ]; then
  USER="$(whoami)"
  export USER
fi

# Count CPUs for Make jobs
if [ "$MACOS" ]; then
  CPUCOUNT="$(sysctl -n hw.ncpu)"
elif [ "$LINUX" ]; then
  CPUCOUNT="$(getconf _NPROCESSORS_ONLN)"
else
  CPUCOUNT=1
fi
export CPUCOUNT

if [ "$CPUCOUNT" -gt 1 ]; then
  export MAKEFLAGS="-j$CPUCOUNT"
  export BUNDLE_JOBS="$CPUCOUNT"
fi

# Enable Terminal.app folder icons
[ "$TERM_PROGRAM" = "Apple_Terminal" ] && export TERMINALAPP=1
if [ "$TERMINALAPP" ]; then
  set_terminal_app_pwd() {
    # Tell Terminal.app about each directory change.
    printf '\e]7;%s\a' "$(echo "file://$HOST$PWD" | sed -e 's/ /%20/g')"
  }
fi
# shellcheck disable=SC2164
[ -s ~/.lastpwd ] && [ "$PWD" = "$HOME" ] &&
  builtin cd "$(cat ~/.lastpwd)" 2>/dev/null
[ "$TERMINALAPP" ] && set_terminal_app_pwd

# Load secrets
# shellcheck source=/dev/null
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# Some post-secret aliases
export HOMEBREW_GITHUB_TOKEN="$GITHUB_TOKEN"
export HUBOT_GITHUB_TOKEN="$GITHUB_TOKEN"
export OCTOKIT_ACCESS_TOKEN="$GITHUB_TOKEN"
