# dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source directory for Bash and PowerShell dotfiles.

## Managed files

- `dot_bashrc` -> `~/.bashrc`
- `dot_config/powershell/profile.ps1` -> `~/.config/powershell/profile.ps1`

## Usage

```bash
chezmoi init https://github.com/junland/dotfiles.git
chezmoi apply
```
