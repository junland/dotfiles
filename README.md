# dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source directory for Bash, Zsh, and PowerShell dotfiles.

## Managed files

- `dot_bashrc` -> `~/.bashrc`
- `dot_zshrc` -> `~/.zshrc`
- `dot_terraformrc` -> `~/.terraformrc`
- `dot_shell_prompt` -> `~/.shell_prompt`
- `dot_config/npm/npmrc` -> `~/.config/npm/npmrc`
- `dot_config/powershell/profile.ps1` -> `~/.config/powershell/profile.ps1` (PowerShell on Unix-like systems)
- `dot_env` -> `~/.env`

On Windows, `run_after_powershell-profile.ps1.tmpl` copies the PowerShell profile
into the user's PowerShell profile path, typically located at `$PROFILE`.

If additional environment variables are needed, they can be added with files in the home directory matching the pattern `~/.env*[-_]*`. These files will also be sourced automatically.

## XDG directory structure

- `~/.config/` stores configuration files, such as settings, themes, and preferences, that dictate how an application behaves.
- `~/.local/` stores application data and state, such as databases, logs, local binaries, and game saves, that applications generate or require to run.

## Usage

```bash
chezmoi init https://github.com/junland/dotfiles.git
chezmoi apply
```
