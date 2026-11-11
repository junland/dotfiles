set -e

repo=$(cd "$(dirname "$0")/.." && pwd)
testDir=$(mktemp -d)
trap 'rm -rf "$testDir"' EXIT
export HOME="$testDir/home with spaces"
mkdir -p "$HOME/.local/bin"
cp "$repo/dot_env" "$HOME/.env"
cp "$repo/dot_shell_prompt" "$HOME/.shell_prompt"
printf '#!/bin/sh\nexit 0\n' > "$HOME/.local/bin/aws_completer"
chmod +x "$HOME/.local/bin/aws_completer"
export PATH="$HOME/.local/bin:/usr/bin:/bin"

source "$repo/dot_$1" || :
test "$GOPATH" = "$HOME/.local/share/go"
test "$CARGO_HOME" = "$HOME/.local/share/cargo"
test "$RUSTUP_HOME" = "$HOME/.local/share/rustup"
test "$XDG_CONFIG_HOME" = "$HOME/.config"
test "$XDG_CACHE_HOME" = "$HOME/.cache"
test "$XDG_DATA_HOME" = "$HOME/.local/share"
test "$NPM_CONFIG_USERCONFIG" = "$HOME/.config/npm/npmrc"
test "$HOMEBREW_NO_ENV_HINTS" = 1
test "$VIRTUAL_ENV_DISABLE_PROMPT" = 1
command -v parse_git_branch >/dev/null
case "$PATH" in "$CARGO_HOME/bin:$GOPATH/bin:$HOME/.local/bin:"*) ;; *) exit 1 ;; esac
alias ll >/dev/null
alias la >/dev/null
alias ansible-local >/dev/null
alias ansible-playbook-local >/dev/null
alias ansible-playbook-localhost >/dev/null
complete -p aws >/dev/null

printf 'export DOTFILES_TEST_LOADED=1\n' > "$HOME/.env-local"
source "$repo/dot_$1" || :
test "$DOTFILES_TEST_LOADED" = 1
printf '%s profile verified\n' "$1"