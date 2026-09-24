# dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source directory for Bash, Zsh, and PowerShell dotfiles.

## Managed files

- `dot_bashrc` -> `~/.bashrc`
- `dot_zshrc` -> `~/.zshrc`
- `dot_config/bash/aphrohdite_theme.sh` -> `~/.config/bash/aphrohdite_theme.sh`
- `dot_config/zsh/aphrohdite_theme.zsh` -> `~/.config/zsh/aphrohdite_theme.zsh`
- `dot_config/powershell/profile.ps1` -> `~/.config/powershell/profile.ps1` (PowerShell on Unix-like systems)

This repository currently targets Bash, Zsh, and PowerShell via `~/.config/powershell/profile.ps1` and does not yet manage the Windows PowerShell 5.1 profile path.

## Usage

```bash
chezmoi init https://github.com/junland/dotfiles.git
chezmoi apply
```
