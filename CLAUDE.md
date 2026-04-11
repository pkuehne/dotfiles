# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles managed by [dots](https://github.com/pkuehne/dots), a custom Python-based dotfile manager. All machine configuration is declared in `dots.toml`. The dots tool handles file deployment (symlinks), tool installation, shell init generation, and git repo cloning.

## Common Commands

```bash
just run         # dots apply — deploy symlinks from files/ to ~
just check       # dots preview — dry-run, show what would change
just tools       # dots tools install — install all configured tools
just status      # dots list — show deployment state of each file
just update      # git pull, dots apply, prompt to source .zshrc
```

You can also call dots directly:
```bash
dots apply
dots preview
dots tools install
dots repos clone
```

## Architecture

### dots.toml

The single source of truth for the entire configuration. Key sections:

- **`[shell]`** — declares managed PATH entries and whether dots owns the shell init dir
- **`[env]`** — environment variables injected into generated shell init
- **`[[tool]]`** — one entry per CLI tool; each entry declares:
  - `check` — command to verify the tool is installed
  - `install` — install method (apt package name, or GitHub release with URL pattern)
  - `[tool.shell]` block with `init` — zsh snippet dots generates into `~/.config/dots/shell.d/050-<name>.sh`
- **`[[repo]]`** — git repos to clone (zsh plugins, tmux plugins, etc.)

### Shell init layering

Dots manages `~/.zshrc` to source everything in `~/.config/dots/shell.d/`. Files in that directory come from two sources:

1. **Auto-generated** by dots from `dots.toml` — environment (`010-env.sh`), PATH (`020-path.sh`), and per-tool snippets (`050-<tool>.sh`)
2. **Copied from `shell/`** — manual shell config files prefixed 030–090 (history, keybindings, completions, plugins, fzf, docker helpers, p10k)

Do not edit files in `~/.config/dots/shell.d/` directly; they are regenerated. Edit `shell/` or `dots.toml` instead.

### files/ directory

Mirrors the home directory structure. `dots apply` symlinks each file from `files/` into `~`. To add a new dotfile, place it at the corresponding path under `files/` (e.g., `files/.config/foo/bar.conf`).

### Adding a new tool

Add a `[[tool]]` entry in `dots.toml` following the existing pattern. For GitHub releases, use `%arch%` as a placeholder (dots substitutes the current architecture). Run `just tools` to install and `just run` to regenerate shell init files.

## Notes

- apt package installs belong in `bootstrap.sh`, not in tool entries, so that the dots playbook never needs sudo for day-to-day use (see feedback memory).
- Custom bat syntaxes (e.g., Just syntax highlighting) are sourced from `.sublime-syntax` files placed in `files/.config/bat/syntaxes/`; rebuild the bat cache after adding new syntaxes with `bat cache --build`.
