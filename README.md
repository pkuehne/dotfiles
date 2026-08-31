# dotfiles

Portable Linux workstation configuration managed entirely by [mise](https://mise.jdx.dev/). Supported targets are x86_64 Omarchy/Arch and Ubuntu/Debian under WSL.

## Bootstrap

Git and mise 2026.8.16 or newer are the only prerequisites. On Omarchy/Arch:

```bash
omarchy pkg add git mise
```

On Ubuntu/WSL, install Git and then install the current mise release:

```bash
sudo apt-get update
sudo apt-get install -y git curl
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
```

Then bootstrap directly from the repository:

```bash
mise bootstrap \
  --from https://gitea.apps.peterkuehne.com/peter/dotfiles.git \
  --from-dir ~/dotfiles \
  --yes \
  --locked
```

Mise clones the repository, installs the declared plugin repositories, links the dotfiles, exposes this configuration globally, and installs the locked tools. Existing files that conflict with managed links are refused rather than overwritten; resolve them and rerun the command.

For an existing checkout:

```bash
cd ~/dotfiles
mise trust
mise bootstrap --yes --locked
```

## Commands

```bash
mise bootstrap --dry-run                 # preview without changing anything
mise bootstrap status                    # inspect repos, dotfiles, and tools
mise bootstrap --yes --locked            # converge using the existing lock
mise bootstrap --from https://gitea.apps.peterkuehne.com/peter/dotfiles.git --from-dir ~/dotfiles --update --yes --locked
mise lock --platform linux-x64 --bump     # intentionally advance tool versions
mise bootstrap dotfiles unapply --dry-run
```

`files/` maps onto `$HOME` using Mise's `symlink-each` mode and a Git manifest. This leaves ordinary target directories in place, links only tracked files, and does not touch unmanaged neighbours.

The retained `justfile` is a convenience interface over Mise: use `just check`, `just apply`, `just reapply`, `just update`, or `just profile work`. It owns no machine state itself.

## Machine profiles

Common configuration lives in `mise/config.toml`. Machine-specific files can be declared in environment configs such as `mise/config.home.toml` and `mise/config.work.toml`, then selected during bootstrap:

```bash
mise bootstrap -E home --yes --locked
mise bootstrap -E work --yes --locked
```

Profile dotfile declarations merge with the common set. When switching profiles, Mise reconciles links it previously managed while preserving unrelated files.

## Tools and shell

The global mise config declares Codex, Go, Node 26, tmux, fzf, eza, fd, ripgrep, bat, dust, lazygit, lazydocker, GitHub CLI, CMake, zoxide, direnv, and Neovim. Git and mise remain bootstrap prerequisites. The committed `mise/mise.lock` targets Linux x64.

Omarchy system binaries deliberately remain earlier on `PATH` and may shadow overlapping mise tools. Use `mise x -- <command>` when the locked copy is required explicitly.

The repository deliberately does not manage `.bashrc`: each host retains its system-specific baseline (including Omarchy's). To opt in, source the portable `~/.bashrcd` loader at the end of that baseline; it reads `~/.config/bashrc.d/*.bash` in lexical order. Each tool-specific fragment returns successfully without side effects when its command is unavailable. The fragments provide mise, zoxide, direnv, and fzf activation, eza aliases, fzf previews, and the Docker `dps`/`dsel` helpers. Zsh, Powerlevel10k, and their plugins are no longer used.

## Omarchy ownership

This repository manages the working Kitty, fontconfig, Neovim, and modified Hyprland monitor configuration. All other Hyprland files remain owned by Omarchy. Theme includes are retained, generated theme/state directories are not tracked, and Omarchy-generated `~/.config/nvim/lua/plugins/theme.lua` remains an unmanaged live file.

The existing `~/.config/tmux/tmux.conf` retains its prefix and keybindings. Mise bootstraps TPM, then TPM installs Resurrect and Continuum declared in the tmux configuration. Continuum saves the tmux environment every 15 minutes and restores the latest save when a new tmux server starts.

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
