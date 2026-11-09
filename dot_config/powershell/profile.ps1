# Managed by chezmoi

# Aliases and functions for PowerShell
Set-Alias ll Get-ChildItem

# If sudo.exe is available, alias it to gsudo.
if (Get-Command sudo.exe -ErrorAction SilentlyContinue) {
    function sudo { gsudo $args }
}

# Set GOPATH
$env:GOPATH = "$HOME/.local/share/go"

# Set CARGO and RUSTUP
$env:CARGO_HOME = "$HOME/.local/share/cargo"
$env:RUSTUP_HOME = "$HOME/.local/share/rustup"

# Set NPM configuration
$env:NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc"