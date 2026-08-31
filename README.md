# dotfiles

Portable Linux dotfiles managed as one [GNU Stow](https://www.gnu.org/software/stow/) package, with CLI versions managed by [mise](https://mise.jdx.dev/). Supported targets are x86_64 Omarchy/Arch and Ubuntu/Debian under WSL.

## Bootstrap

On a fresh machine:

```bash
curl -fsSL https://gitea.apps.peterkuehne.com/peter/dotfiles/raw/branch/main/bootstrap.sh | bash
```

The bootstrap installs only Git, GNU Stow, and mise, then clones this repository when needed. It does not deploy dotfiles or install the declared tools automatically. Run the command it prints:

```bash
cd ~/.config/dotfiles
mise x just@latest -- just setup
```

Stow refuses to replace existing regular files, so resolve any reported conflicts before the first deployment.

## Commands

```bash
just check    # simulate Stow; make no changes
just link     # restow files
just unlink   # remove Stow-managed links
just tools    # install only versions/artifacts in mise.lock
just setup    # link, then install locked tools
just update   # git pull, restow, and use the existing lock
just upgrade  # advance fuzzy selectors and refresh the Linux x64 lock
```

`files/` is the sole Stow package and maps directly onto `$HOME`. Stow runs with `--no-folding`, leaving ordinary target directories around individually managed links.

## Tools and shell

The global mise config declares Codex, Go, Node 26, tmux, fzf, eza, fd, ripgrep, bat, dust, just, lazygit, lazydocker, GitHub CLI, CMake, zoxide, direnv, and Neovim. Git remains a system/bootstrap dependency. The committed `mise.lock` targets Linux x64.

Omarchy system binaries deliberately remain earlier on `PATH` and may shadow overlapping mise tools. Use `mise x -- <command>` when the locked copy is required explicitly.

The managed `.bashrc` sources Omarchy's Bash defaults when present. On Ubuntu/WSL it provides mise, zoxide, direnv, and fzf activation, eza aliases, fzf previews, and the Docker `dps`/`dsel` helpers. Zsh, Powerlevel10k, and their plugins are no longer used.

## Omarchy ownership

This repository manages the working Kitty, fontconfig, Neovim, and modified Hyprland monitor configuration. All other Hyprland files remain owned by Omarchy. Theme includes are retained, generated theme/state directories are not tracked, and Omarchy-generated `~/.config/nvim/lua/plugins/theme.lua` remains an unmanaged live file.

The existing `~/.config/tmux/tmux.conf` is retained as a Stow target, including its prefix, keybindings, and TPM plugin declarations.

Omarchy migrations and theme tooling can write through managed symlinks. Review `git diff` after an Omarchy update or migration. Theme switching should continue to update the includes under `~/.local/state/omarchy/current/theme` without changing tracked theme state.

## SSH and signed commits

The repository contains only the SSH public key, allowed-signers file, and SSH client configuration. Private keys, credentials, known-host files, control sockets, and agent sockets must never be committed.

Provision `~/.ssh/id_peter` separately before creating signed commits or tags, and keep its permissions restricted:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_peter
```

On WSL, also configure your preferred SSH agent integration separately. Git uses SSH-format signing and the tracked public key/allowed-signers file.

## Ubuntu/WSL notes

The fallback Bash configuration expects a normal interactive Bash shell. After setup, start a new shell with `exec bash`. GUI-only Omarchy configuration may remain linked on WSL but is inert unless those applications are installed.
