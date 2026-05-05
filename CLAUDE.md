# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal dotfiles for shell, editor, git, tmux, and VS Code configuration. Designed to be deployed via [Strap](https://github.com/MikeMcQuaid/strap) but also runnable standalone.

## Deployment model — read before editing

`script/setup` symlinks every top-level file/directory into `$HOME` with a leading dot. This has several consequences that affect how you should edit files:

- **`.sh` suffix is stripped on deploy.** `shrc.sh` becomes `~/.shrc`, `zshrc.sh` becomes `~/.zshrc`, `shprofile.sh` becomes `~/.shprofile`, etc. The `.sh` suffix exists only so editors apply shell syntax highlighting in the repo. Don't add references to the repo-side filename (e.g. `~/.shrc.sh`) — that path doesn't exist post-install.
- **`script/`, `*.md`, `*.txt` are skipped.** Anything inside `script/` is run, not symlinked.
- **`vscode-settings.json` is special-cased.** It deploys to `~/Library/Application Support/Code/User/settings.json` on macOS (different paths on Linux/Windows).
- **Files in `~` are symlinks back into this repo.** Editing `~/.shrc` edits `shrc.sh` here. This is the intended workflow.

To re-deploy after changes: `script/setup` (idempotent — re-links existing symlinks, removes and re-links non-symlinks).

## Shell configuration architecture

Bash and zsh share configuration through two common files, each sourced by both shells' rc/profile:

- `shrc.sh` — sourced by `bashrc.sh` and `zshrc.sh`. Aliases, PATH setup, editor selection, platform-conditional logic, helper functions (`add_to_path_start`, `quiet_which`, `field`, `json`, etc.). **Edit here for changes that should apply to both shells.**
- `shprofile.sh` — sourced by `bash_profile.sh` and `zprofile.sh`. Login-shell setup: `umask`, history sizes, OS detection (`$MACOS`/`$LINUX`/`$WINDOWS`/`$UNIX`), `$CPUCOUNT`, secrets loading from `~/.secrets`.

Zsh- or bash-specific behavior (history options, key bindings, completion) belongs in `zshrc.sh` / `bashrc.sh` respectively, not in `shrc.sh`.

OS detection variables (`$MACOS`, `$LINUX`, `$WINDOWS`, `$UNIX`) are exported by `shprofile.sh` and also re-derived in `script/setup` — use them for platform-conditional blocks.

## Other moving parts

- **`script/strap-after-setup`** — invoked by Strap after the Brewfile finishes. Configures TouchID for sudo, runs the asdf and VS Code installers, installs Perl deps, clones Vundle. Runs once per machine.
- **`script/install-asdf-plugins`** — installs and pins specific versions for clojure/elm/elixir/erlang/go/idris/nodejs/python/ruby. Versions are pinned inline; bump them here.
- **`script/install-coding-agent-plugins`** — installs Claude Code plugins via `claude plugin install`. Runs after Claude Code is installed.
- **`vimrc`** — Vundle-based. Plugins are listed between `vundle#begin()` and `vundle#end()`. Run `:PluginInstall` in vim after adding entries.
- **`vscode-extensions`** — newline-separated extension IDs. `script/install-vscode-extensions` installs any not already present (idempotent).

## No build, no tests

This repo has no test suite, no CI, and no linter configured. Shell files include `# shellcheck disable=...` directives, suggesting shellcheck is the convention if validation is needed — run `shellcheck shrc.sh` etc. manually.

Verify changes by re-running `script/setup` and opening a fresh shell, not by running tests.
