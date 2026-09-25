# Managed by chezmoi

# Aliases and functions for PowerShell
Set-Alias ll Get-ChildItem

# If sudo.exe is available, alias it to gsudo.
if (Get-Command sudo.exe -ErrorAction SilentlyContinue) {
    function sudo { gsudo @args }
}