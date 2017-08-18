#set -x

if [[ -f ~/.bash.env ]]; then
	source ~/.bash.env
fi

# Aliases
#
alias tmux="TERM=screen-256color-bce tmux"

# Functions
#
_path_usrlocalbin_before_usrbin() {
	PATH=$(echo "$PATH" | sed 's#/usr/bin#usr-bin#; s#/usr/local/bin#usr-local-bin#; s#usr-local-bin#/usr/bin#; s#usr-bin#/usr/local/bin#')
}

_path_usrbin_before_usrlocalbin() {
	PATH=$(echo "$PATH" | sed 's#/usr/bin#usr-bin#; s#/usr/local/bin#usr-local-bin#; s#usr-bin#/usr/local/bin#; s#usr-local-bin#/usr/bin#')
}

_add_path_to_loadpath() {
	local load_path=$1

	if [[ ! -d "$load_path" ]] && [[ "./node_modules/.bin" != "$load_path" ]]; then
		#echo "Error: Unable to find path: $load_path, aborting"
		return
	else
		if echo "$PATH" | grep -q "$load_path"; then
			#echo "Error: $PATH already contains $load_path"
			return
		else
			#echo "Adding $load_path to $PATH"
			export PATH="$PATH:$load_path"
			#echo "Success"
		fi
	fi
}

_add_path_to_loadpath ~/bin

# Language support
#
source /usr/local/opt/asdf/asdf.sh

# Go
#
test -z "$GOPATH" && export GOPATH=~
test -z "$GOROOT" \
	&& [[ -d /usr/local/opt/go ]] \
	&& GOROOT=/usr/local/opt/go/libexec \
	&& export GOROOT
#[[ -s "~/.gvm/scripts/gvm" ]] && source "~/.gvm/scripts/gvm"

_add_path_to_loadpath '/usr/local/sbin'

# Node/NPM
#
test ! -x /usr/local/bin/node && _add_path_to_loadpath './node_modules/.bin'

# Perl
#
# lib::local
test -z "$PERL5LIB" && eval "$(perl -I~/perl5/lib/perl5 -Mlocal::lib)"

# Python
test -d "~/Library/Python/2.7/bin" && _add_path_to_loadpath "~/Library/Python/2.7/bin"

# Ruby
#
# Use chruby for Ruby version management
if [[ -d /usr/local/opt/chruby/ ]]; then
	test -f /usr/local/opt/chruby/share/chruby/chruby.sh && . /usr/local/opt/chruby/share/chruby/chruby.sh
	# Autoloading takes forever
	test -f /usr/local/opt/chruby/share/chruby/auto.sh && . /usr/local/opt/chruby/share/chruby/auto.sh
	#RUBIES+=(/usr/local/rubies/*)
fi

# ChefDK
test -d '/opt/chefdk/bin' && \
	_add_path_to_loadpath '/opt/chefdk/bin'

# Generic environment
VISUAL=$(which vim)
export VISUAL

### Added by the Heroku Toolbelt
test -d "/usr/local/opt/heroku/bin" && \
	_add_path_to_loadpath "/usr/local/opt/heroku/bin"

# Bash completion for all!
test -f /usr/local/etc/bash_completion && \
	source /usr/local/etc/bash_completion

# Powerline
POWERLINE_PATH=/usr/local/lib/python2.7
test -f "$POWERLINE_PATH"/site-packages/powerline/bindings/bash/powerline.sh && \
	test -f "$(which powerline-daemon)" && \
	powerline-daemon -q && \
	export POWERLINE_BASH_CONTINUATION=1 POWERLINE_BASH_SELECT=1 && \
	source "$POWERLINE_PATH"/site-packages/powerline/bindings/bash/powerline.sh

# GnuPG
if [ -f ~/.gpg-agent-info ]; then
	source ~/.gpg-agent-info
	export GPG_AGENT_INFO
	export SSH_AUTH_SOCK
	export SSH_AGENT_PID
else
	exec /usr/local/bin/gpg-agent --enable-ssh-support --daemon --write-env-file
fi

HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ANALYTICS

#set +x
