# dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source directory for Bash and PowerShell dotfiles.

## Managed files

- `dot_bashrc` -> `~/.bashrc`
- `dot_config/powershell/profile.ps1` -> `~/.config/powershell/profile.ps1` (PowerShell on Unix-like systems)

This repository currently targets Bash and PowerShell via `~/.config/powershell/profile.ps1` and does not yet manage the Windows PowerShell 5.1 profile path.

## Usage

```bash
chezmoi init https://github.com/junland/dotfiles.git
chezmoi apply
```
