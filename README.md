# dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source directory for Bash and PowerShell dotfiles.

## Managed files

- `dot_bashrc` -> `~/.bashrc`
- `dot_config/powershell/profile.ps1` -> `~/.config/powershell/profile.ps1` (PowerShell on Unix-like systems)

For Windows PowerShell, the profile path is typically under `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`.

## Usage

```bash
chezmoi init https://github.com/junland/dotfiles.git
chezmoi apply
```
