# Repository guidance

## Architecture

- `files/` is one GNU Stow package targeting `$HOME`.
- `files/.config/mise/config.toml` declares tools; `mise.lock` locks Linux x64 artifacts.
- The `link` recipe runs `stow --restow --no-folding` directly; Stow conflicts are never modified automatically.
- `bootstrap.sh` supports Arch/Omarchy and Debian/Ubuntu and installs only Git, Stow, and mise.

## Normal workflow

```bash
just check
just link
just tools
just update
just upgrade
```

`update` must preserve the existing lock. Only `upgrade` may advance fuzzy mise selectors and update the lockfile. Never use `stow --adopt`.

## Ownership boundaries

- Preserve the tracked `~/.config/tmux/tmux.conf` and its existing keybindings and TPM declarations.
- Track only Hyprland files that differ from `/usr/share/omarchy/config/hypr`; currently that is `monitors.lua`.
- Keep Omarchy theme includes in Kitty and Neovim integration intact.
- Never track Omarchy-generated `nvim/lua/plugins/theme.lua` or Omarchy theme/state directories.
- Omarchy migrations can write through Stow symlinks; inspect resulting diffs.

## Sensitive files

Only public SSH material and client configuration belong here. Never add private keys, credentials, `known_hosts`, agent/control sockets, or other secrets. Private SSH keys are provisioned separately.

## Validation

Do not deploy to the real home or install tools merely to test a change. Use `bash -n`, ShellCheck when available, `just --dry-run`, mise's locked install dry-run, and a temporary Stow target. Neovim checks should use temporary XDG directories and cover both the presence and absence of the generated Omarchy theme file.
