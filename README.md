# dotfiles

Portable Linux workstation configuration managed entirely by
[mise](https://mise.jdx.dev/). Supported targets are x86_64 Arch (the laptop
runs the Hyprland desktop described below) and Ubuntu/Debian under WSL.

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
just git-key    # print this host's git SSH key, creating it if missing
just desktop    # install the Arch laptop desktop packages and services
just desktop-diff  # desktop packages missing, AUR packages no script covers
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
vivid, the Neovim colorscheme, and on the desktop Hyprland, hyprlock,
hyprtoolkit and the titan shell. Hyprland's palette lives in
`files/.config/hypr/colors.lua`.

bat is the exception to "first-party everywhere": it ships no Tokyo Night, so
`files/.config/bat/themes/tokyonight_moon.tmTheme` is vendored and compiled by
`mise run bat-cache` (wired into bootstrap and `just up`). delta inherits it.

## Desktop (Arch laptop)

The laptop runs Hyprland with a Lua config in `files/.config/hypr/`, split by
concern: `hyprland.lua` only `require`s the others (`env`, `input`, `layout`,
`look`, `animations`, `binds`, and one file per app under `rules/`). The
layout is Hyprland's scrolling layout. `hyprlock.conf` and `hypridle.conf`
handle locking and idle; `hyprtoolkit.conf` themes Hyprland's own dialogs.

The shell is titan, a custom Quickshell config in its own repo,
[pkuehne/titan](https://github.com/pkuehne/titan), which `mise.personal.toml` clones
to `~/.config/quickshell/titan`: bar, workspaces, notifications, launcher,
clipboard history, wallpaper picker, keybind popup, and the volume, brightness
and media-key handling. Hyprland binds reach it over IPC
(`qs -c titan ipc call <target> <function>`).

Desktop packages come from pacman, not mise. `just desktop` installs
`desktop/packages.txt`, 1Password from the AUR, and enables the services.
Optional apps install on first use from titan's launcher
(`launcher/install/*.sh`); `just desktop-diff` lists AUR packages that neither
path covers.

nostro ([pkuehne/nostro](https://github.com/pkuehne/nostro)) is a second Quickshell
profile, cloned the same way to `~/.config/quickshell/nostro`. Bootstrap passes
`--skip-dirty`, so uncommitted work in either shell is left alone.

The niri config in `files/.config/niri/` is kept for switching back.

## SSH and signed commits

The repository contains only the `id_peter` public key and SSH client
configuration. Private keys, credentials, known-hosts files, control sockets
and agent sockets must never be committed.

Each host has its own git key. `just git-key` (also run at the end of
`bootstrap.sh`) creates `~/.ssh/id_<host>_git` with the comment
`<user>@<host> git` if it is missing, then prints the public key: add it to
GitHub and Gitea for both authentication and signing. It also writes the
untracked `~/.config/git/signing.config` (the signing key) and
`~/.ssh/allowed_signers` (this host's key only). ssh selects the key with
`IdentityFile ~/.ssh/id_%L_git`; commit and tag signing is always on. GitHub repos are
cloned over https and pushed over SSH, and `bootstrap.sh` finishes by switching the
dotfiles `origin` to SSH.

`id_peter` is offered to every host as well. On the laptop its private key
lives in 1Password, whose agent Hyprland exports as `SSH_AUTH_SOCK`; anywhere
else, provision `~/.ssh/id_peter` (mode 600) separately if it is needed.

## Ubuntu/WSL notes

Desktop configuration (Hyprland, titan, kitty and the like) stays linked on WSL
but is inert unless those applications are installed.
