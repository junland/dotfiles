#!/bin/sh
# Unix integration test. No writes to the caller's home or chezmoi state.
set -eu
repo=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
home="$tmp/home with spaces"
mkdir -p "$home" "$tmp/tools"
cm=$(command -v chezmoi)
ps=$(command -v pwsh)
apply() { env -i HOME="$home" PATH=/usr/bin:/bin "$cm" -S "$repo" apply; }
apply
printf '%s\n' '# preserve user changes' >> "$home/.config/powershell/profile.ps1"
apply
grep -qx '# preserve user changes' "$home/.config/powershell/profile.ps1"
test ! -e "$home/tests"
test ! -e "$home/.skills"
test -d "$home/.terraform.d/plugin-cache"
printf 'BACKUP_LOADED=yes\n' > "$home/.env-backup"
printf 'export LOCAL_LOADED=yes\n' > "$home/.config/shell/local"

# compinit may use system utilities, but optional completion generators are absent.
for tool in chmod date mkdir mv rm sed uname; do
    ln -s "$(command -v "$tool")" "$tmp/tools/$tool"
done
printf '#!/bin/sh\nexit 0\n' > "$tmp/aws_completer"
chmod +x "$tmp/aws_completer"
for shell in bash zsh; do
    case $shell in bash) flags='--noprofile --norc';; zsh) flags=-f;; esac
    env -i HOME="$home" PATH="$tmp/tools" TOOLS="$tmp/tools" TERM=dumb SHELL_NAME="$shell" \
        "$(command -v "$shell")" $flags -ic '
        set -e
        PROMPT_COMMAND=:
        precmd() { :; }
        XDG_DATA_HOME="$HOME/data"
        HISTFILE="$HOME/history"
        profile="$HOME/.${SHELL_NAME}rc"
        . "$profile"
        first=$PATH
        . "$profile"
        test "$first" = "$PATH"
        test "$PATH" = "$HOME/data/cargo/bin:$HOME/data/go/bin:$HOME/.local/bin:$TOOLS"
        test "$LOCAL_LOADED" = yes
        test -z "${BACKUP_LOADED-}"
        test "$HISTFILE" = "$HOME/history"
        test "$PROMPT_COMMAND" = :
        test -z "$(precmd)"
        alias ll >/dev/null
        # Also cover an existing AWS registration on reload.
        PATH="$TOOLS/..:$PATH"
        . "$profile"
        if [ "$SHELL_NAME" = bash ]; then
            complete -p aws >/dev/null
        else
            test -n "${_comps[aws]-}"
        fi
    '
done
env -i HOME="$home" PATH=/usr/bin:/bin "$ps" -NoLogo -NonInteractive -Command '
    $ErrorActionPreference = "Stop"
    Get-Alias ansible-playbook-localhost | Out-Null
    $first = $env:PATH
    . $PROFILE.CurrentUserAllHosts
    if ($first -cne $env:PATH -or !$first.EndsWith(":/usr/bin:/bin") -or
        !$first.StartsWith("$HOME/.local/share/cargo/bin:")) { throw "Unexpected PATH: $env:PATH" }
'

# Exercise the rendered installer with a fake console host, never the real profile.
{ printf '%s' '{{ $_ := set .chezmoi "os" "windows" }}'; cat "$repo/run_after_powershell-profile.ps1.tmpl"; } |
    env -i HOME="$home" PATH=/usr/bin:/bin "$cm" -S "$repo" execute-template > "$tmp/install.ps1"
printf '#!/bin/sh\nprintf "%%s\\n" "$HOME/Documents/PowerShell/profile.ps1"\n' > "$tmp/tools/pwsh"
chmod +x "$tmp/tools/pwsh"
env -i HOME="$home" PATH="$tmp/tools" TOOLS="$tmp/tools" INSTALLER="$tmp/install.ps1" "$ps" -NoProfile -Command '
    $ErrorActionPreference = "Stop"
    $env:PATH = $env:TOOLS
    & $env:INSTALLER
    $path = "$HOME/Documents/PowerShell/profile.ps1"
    . $path
    Get-Alias ansible-playbook-localhost | Out-Null
    Set-Content -LiteralPath $path -Value "# customized"
    & $env:INSTALLER
    if ((Get-Content -LiteralPath $path) -ne "# customized") { throw "Profile overwritten" }
'
