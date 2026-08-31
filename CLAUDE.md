# Repository guidance

## Architecture

- `mise.toml` is the single machine-bootstrap and tool configuration.
- `mise.lock` locks Linux x64 tool artifacts.
- `files/` maps onto `$HOME` through Mise `symlink-each` mode with a Git manifest.
- Mise bootstraps TPM; TPM installs the plugins declared in `tmux.conf`.
- `justfile` provides convenience recipes over Mise and owns no machine state.
- Fresh machines bootstrap with `mise bootstrap --from`; Git and mise are the only prerequisites.

## Normal workflow

```bash
mise bootstrap --dry-run
mise bootstrap status
mise bootstrap --yes --locked
mise bootstrap --update --yes --locked
mise lock --platform linux-x64 --bump
```

Normal bootstrap and repository updates must preserve the existing lock. Only an intentional upgrade may use `mise lock --platform linux-x64 --bump`.

## Ownership boundaries

- Preserve the tracked `~/.config/tmux/tmux.conf`, its existing keybindings, plugin declarations, and TPM initialization as the final line.
- Track only Hyprland files that differ from `/usr/share/omarchy/config/hypr`; currently that is `monitors.lua`.
- Keep Omarchy theme includes in Kitty and Neovim integration intact.
- Never track Omarchy-generated `nvim/lua/plugins/theme.lua` or Omarchy theme/state directories.
- Omarchy migrations can write through managed symlinks; inspect resulting diffs.

## Sensitive files

Only public SSH material and client configuration belong here. Never add private keys, credentials, `known_hosts`, agent/control sockets, or other secrets. Private SSH keys are provisioned separately.

## Validation

Do not deploy to the real home or install tools merely to test a change. Use `mise bootstrap --dry-run`, targeted bootstrap status commands, and an isolated temporary `HOME`, `XDG_CONFIG_HOME`, `MISE_DATA_DIR`, and `MISE_STATE_DIR` for apply tests. Neovim checks should use temporary XDG directories and cover both the presence and absence of the generated Omarchy theme file.
