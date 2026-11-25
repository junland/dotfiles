# dotfiles

```sh
chezmoi init https://github.com/junland/dotfiles.git
chezmoi managed
chezmoi diff
chezmoi apply
```

Review the diff: on Unix the interactive rc files, prompt, npm config and
Terraform CLI config are ordinary managed files, not merges. Move existing
customizations into a trusted `~/.config/shell/local` before replacing an rc.
That file is shell code shared by Bash and Zsh, read last on each source.
Review and move any intended settings from old `~/.env*` files yourself;
the new profiles neither execute nor delete backups.

| Platform | Targets and startup |
| --- | --- |
| Linux, macOS | `~/.bashrc`, `~/.zshrc`, `~/.config/shell/env`, `~/.shell_prompt`, `~/.config/npm/npmrc`, `~/.local/bin/`, `~/.terraformrc` and `~/.terraform.d/plugin-cache/`. PowerShell gets `~/.config/powershell/dotfiles.ps1` and an all-hosts loader if absent. |
| Windows | `~/.config/npm/npmrc`, `~/.local/bin/` and `~/.config/powershell/dotfiles.ps1`. An after-apply script asks `pwsh`, or `powershell` if absent, for its actual current-user console profile path and creates a loader **only if missing**. No Unix shell or Terraform configuration. |

**Bash:** Interactive non-login startup reads `.bashrc`: system `/etc/bashrc`
if present, shared environment and PATH, prompt, history defaults, AWS completion
if available, then `local`. Login Bash reads the first of `.bash_profile`,
`.bash_login`, `.profile` after `/etc/profile`; this repo doesn't replace those.
If your login profile doesn't already chain to `.bashrc`, add
`[ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"` there.

**Zsh:** With default `ZDOTDIR`, `.zshenv` and (for login) `.zprofile` precede
interactive `.zshrc`; login `.zlogin` follows. The managed rc loads the shared
environment, prompt and history, initializes completion unless already active,
adds AWS completion if needed, then reads `local`. Put packaged completions
on `fpath` before `compinit`, or use your system completion package. The
profiles no longer execute CLI completion generators on startup. Git branch
and terminal title handling are left to the user's prompt/terminal integration.

**PowerShell:** Machine profiles run before user profiles; all-hosts precedes
host-specific at each scope. The loader dot-sources `dotfiles.ps1` for aliases,
environment defaults and PATH. On upgrades, if a profile already exists
(including the old copied profile), or you use another host, edition or XDG
profile directory, add `. "$HOME/.config/powershell/dotfiles.ps1"` once in the
appropriate `$PROFILE` instead of keeping two copies of the old settings.

**Recovery:** Start `bash --noprofile --norc`, `zsh -f` or `pwsh -NoProfile`
(`powershell -NoProfile` for Windows PowerShell). Inspect `chezmoi diff` and
the profile chain above before applying. For an interactive Unix trace use
`bash -ix` or `zsh -ix`; traces may include private environment values.

**Tests:** On Unix with chezmoi, Bash, Zsh and `pwsh` on PATH, run
`sh tests/shell-profiles.sh`. It applies twice inside a private home, reloads
interactive profiles without optional CLIs, and checks the Windows loader
against a temporary console-profile path. This is not a native Windows test.
