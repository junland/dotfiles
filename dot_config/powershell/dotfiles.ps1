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
if (!$env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME = "$HOME/.config" }
if (!$env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME = "$HOME/.cache" }
if (!$env:XDG_DATA_HOME) { $env:XDG_DATA_HOME = "$HOME/.local/share" }
if (!$env:GOPATH) { $env:GOPATH = "$env:XDG_DATA_HOME/go" }
if (!$env:CARGO_HOME) { $env:CARGO_HOME = "$env:XDG_DATA_HOME/cargo" }
if (!$env:RUSTUP_HOME) { $env:RUSTUP_HOME = "$env:XDG_DATA_HOME/rustup" }

# Node.js configuration
if (!$env:NPM_CONFIG_USERCONFIG) { $env:NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc" }

# Homebrew configuration
if (!$env:HOMEBREW_NO_ENV_HINTS) { $env:HOMEBREW_NO_ENV_HINTS = '1' }

# Executable paths
& {
    $separator = [IO.Path]::PathSeparator
    $dirs = @()
    if (Test-Path -LiteralPath "$HOME/.local/bin" -PathType Container) {
        $dirs += Join-Path $HOME '.local/bin'
    }
    $dirs += Join-Path ($env:GOPATH.Split($separator)[0]) bin
    $dirs += Join-Path $env:CARGO_HOME bin
    foreach ($dir in $dirs) {
        $entries = ([string]$env:PATH).Split($separator)
        if ($separator -eq ';') {
            if ($entries.Replace('/', '\') -contains $dir.Replace('/', '\')) { continue }
        } elseif ($entries -ccontains $dir) { continue }
        if ($env:PATH) { $env:PATH = "$dir$separator$env:PATH" } else { $env:PATH = $dir }
    }
}