# shellcheck shell=bash

# check if this is a login shell
[ "$0" = "-bash" ] && export LOGIN_BASH=1

# run bash_profile if this is not a login shell
# shellcheck source=/dev/null
[ -z "$LOGIN_BASH" ] && source ~/.bash_profile

# load shared shell configuration
# shellcheck source=/dev/null
source ~/.shrc

# History
export HISTFILE="$HOME/.bash_history"
export HISTCONTROL="ignoredups"
export PROMPT_COMMAND="history -a"
export HISTIGNORE="&:ls:[bf]g:exit"
