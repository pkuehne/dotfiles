# Thin wrappers around mise — everything real is declared in mise.toml.
# No -C: every config in ~/.config/mise/conf.d is global, so a bare
# `mise bootstrap` converges this repo and any overlay layered on top of it.
# Run from $HOME: inside the repo, mise.toml loads as a project config and
# outranks the overlays in conf.d.
set working-directory := '..'

default: help

help:
  just --list

# Install mise itself
install:
  curl -fsSL https://mise.run | sh
  mise --version

# Deploy the lightweight default: dotfiles, plugin repos, editor and CLI tools.
apply:
  mise bootstrap --yes --skip-dirty

# Install the full workstation layer, including language runtimes.
full:
  {{justfile_directory()}}/bootstrap.sh full

# Print this host's git SSH public key, creating the key first if it is missing
git-key:
  mise run git-key

# Install the laptop desktop: Hyprland, titan's dependencies, services (Arch only)
desktop:
  {{justfile_directory()}}/desktop/install.sh

# List missing desktop packages, and AUR packages no install script covers
desktop-diff:
  #!/usr/bin/env bash
  set -euo pipefail
  dir={{justfile_directory()}}
  echo "Missing desktop packages:"
  comm -23 <(sort "$dir/desktop/packages.txt") <(pacman -Qq | sort)
  echo "AUR packages not installed by any script:"
  comm -13 <(grep -ho 'yay -S --needed [^ ]*' "$HOME"/.config/quickshell/titan/launcher/install/*.sh | awk '{print $NF}' | sort) <(pacman -Qqm | sort)

# Show what `just apply` would change, without changing anything
plan:
  mise bootstrap --dry-run --skip-dirty

# Symlink dotfiles only
link:
  mise bootstrap --only dotfiles --yes

# Show the state of every managed dotfile
status:
  mise bootstrap dotfiles status

# Show the pending dotfile changes in detail
diff:
  mise bootstrap dotfiles diff

# Upgrade pinned tool versions, then refresh completions
up:
  mise run up

# Regenerate zsh completions
completions:
  mise run completions

# Lint shell scripts with shellcheck
lint:
  cd {{justfile_directory()}} && git ls-files -z --cached --others --exclude-standard '*.sh' '*.bash' | xargs -0 shellcheck

# Make zsh the login shell
change-shell:
  mise run change-shell "$(command -v zsh)"
