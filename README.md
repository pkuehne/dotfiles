# dotfiles

Portable Linux workstation configuration managed entirely by
[mise](https://mise.jdx.dev/). Supported targets are x86_64 Omarchy/Arch and
Ubuntu/Debian under WSL.

## Bootstrap

Git and curl are the only prerequisites.

```bash
cd ~ && git clone https://github.com/pkuehne/dotfiles.git
~/dotfiles/bootstrap.sh
```

This installs the **minimal** profile: the shell, Neovim, tmux, Git helpers,
search/navigation tools, and their plugins, but no language runtimes. For a
development workstation, install the additional Node and Go runtimes and
development tools explicitly:

```bash
~/dotfiles/bootstrap.sh full
```

The clone path is mandatory — `bootstrap.sh` refuses to run from anywhere else,
because mise does no templating on a `[dotfiles]` source and the paths in
`mise.toml` are absolute under `~/dotfiles`.

The script installs mise if it is missing, symlinks the selected profile into
`~/.config/mise/conf.d/`, and runs `mise bootstrap`, which clones the plugin
repositories, links the dotfiles, installs the selected pinned tools and
generates zsh completions. Existing real files that conflict with a managed
link are refused rather than overwritten; resolve them and rerun. Switching
from `full` to the minimal profile prevents future installs of the full-only
tools; it intentionally does not delete already-installed runtimes.

## Commands

```bash
just            # list recipes
just apply      # mise bootstrap --yes
just full       # install the full workstation profile
just plan       # preview without changing anything
just diff       # pending dotfile changes in detail
just status     # state of every managed dotfile
just link       # dotfiles only; also prunes links left by deleted files
just up         # bump pinned tool versions, then refresh completions
```

`files/` maps onto `$HOME` using mise's `symlink-each` mode and a Git manifest:
real directories, symlinked leaf files, unmanaged neighbours untouched.

## Layering a private overlay

`~/.config/mise/conf.d/*.toml` is the global config directory — mise merges
every file in it, alphabetically, on every invocation from any directory. A
second (private) repo can therefore add machine-specific config on top of this
one by symlinking its own `mise.toml` in under a later-sorting name. A bare
`mise bootstrap` then converges both in one pass.

The overlay replaces an individual file by declaring the **same target path**;
whole-file `[dotfiles]` entries merge by target path and the later layer wins.
`~/.ssh/*` and `~/.claude/settings.json` are excluded from the `"~"` directory
walk and given their own entries precisely so they can be replaced this way.
Git needs no entry at all: `files/.config/git/config` ends with
`[include] path = local.config`, which git silently skips when absent.

## Shells

Both shells use the same layout — numbered fragments in
`files/.config/<shell>/rc.d/`, linked into `$HOME` by the same `symlink-each`
walk as every other dotfile.

zsh is primary. `mise.toml` sets it as the login shell, `ZDOTDIR` points at
`~/.config/zsh`, and `~/.config/zsh/.zshrc` sources `$ZDOTDIR/rc.d/[0-9]*.zsh`
in strict order: p10k instant prompt, options, history, mise activation,
completions, plugins, fzf, aliases, zoxide, docker helpers, vi-mode fixes,
direnv, p10k.

bash is a working fallback. A single marked block in `~/.bashrc` sources
`~/.config/bash/rc.d/*.bash`, giving bash mise, starship, eza aliases, fzf, and
the docker helpers. Each fragment returns cleanly when its tool is absent.

## Theme

Tokyo Night Moon throughout: bat, delta, fzf, ghostty, kitty, lazygit, tmux,
vivid, and the Neovim colorscheme. Ghostty additionally uses the Tokyo Night
Aurora edge glow and a cursor-sweep shader on the full-workstation profile only.
Their repositories are declaratively cloned by `./bootstrap.sh full` into
`~/.config/ghostty/shaders/`; its post-repository hook generates a clean Tokyo
Night Aurora variant without modifying the upstream checkout. Ghostty is not
launched on the space-constrained VM profile, so its shader dependencies are
not cloned there. There is no separate Ghostty shader installer.

bat is the exception to "first-party everywhere": it ships no Tokyo Night, so
`files/.config/bat/themes/tokyonight_moon.tmTheme` is vendored and compiled by
`mise run bat-cache` (wired into bootstrap and `just up`). delta inherits it.

## Omarchy ownership

This repository manages Kitty, ghostty, fontconfig, Neovim and the modified
Hyprland monitor configuration. All other Hyprland files remain owned by
Omarchy, and generated theme/state directories are not tracked. Omarchy
migrations can write through managed symlinks — review `git diff` after an
update.

## SSH and signed commits

The repository contains only the SSH public key, allowed-signers file and SSH
client configuration. Private keys, credentials, known-hosts files, control
sockets and agent sockets must never be committed.

Provision `~/.ssh/id_peter` separately before creating signed commits or tags:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_peter
```

## Ubuntu/WSL notes

GUI-only Omarchy configuration stays linked on WSL but is inert unless those
applications are installed.
