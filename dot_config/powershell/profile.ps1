# Managed by chezmoi

# Directory listings
function Get-AllChildren { Get-ChildItem -Force @args }
Set-Alias ll Get-AllChildren
Set-Alias la Get-AllChildren

# Local Ansible commands
function ansible-local { ansible -i 'localhost,' -c local @args }
function ansible-playbook-local { ansible-playbook -i 'localhost,' -c local @args }
Set-Alias ansible-playbook-localhost ansible-playbook-local

# Elevation
if (Get-Command sudo.exe -ErrorAction SilentlyContinue) {
    Set-Alias gsudo sudo.exe
}

# Environment
$env:GOPATH = "$HOME/.local/share/go"
$env:CARGO_HOME = "$HOME/.local/share/cargo"
$env:RUSTUP_HOME = "$HOME/.local/share/rustup"

$env:XDG_CONFIG_HOME = "$HOME/.config"
$env:XDG_CACHE_HOME = "$HOME/.cache"
$env:XDG_DATA_HOME = "$HOME/.local/share"

# Node.js configuration
$env:NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc"

# Homebrew configuration
$env:HOMEBREW_NO_ENV_HINTS = '1'

# Executable paths
$pathSeparator = [System.IO.Path]::PathSeparator
if (Test-Path -LiteralPath "$HOME/.local/bin" -PathType Container) {
    $env:PATH = "$HOME/.local/bin$pathSeparator$env:PATH"
}
$env:PATH = "$env:CARGO_HOME/bin$pathSeparator$env:GOPATH/bin$pathSeparator$env:PATH"