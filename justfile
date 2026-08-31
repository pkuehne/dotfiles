set shell := ["bash", "-euo", "pipefail", "-c"]

default: help

# List available recipes
help:
    @just --list

# Link dotfiles and install locked tools
setup: link tools

# Deploy the Stow package into $HOME
link:
    stow --restow --verbose --no-folding --target="${HOME}" files

# Simulate Stow without changing $HOME
check:
    stow --simulate --verbose --no-folding --target="${HOME}" files

# Remove links created by Stow
unlink:
    stow --delete --verbose --no-folding --target="${HOME}" files

# Install exactly the tool versions and artifacts recorded in mise.lock
tools:
    MISE_IGNORED_CONFIG_PATHS="${HOME}/.config/mise" MISE_GLOBAL_CONFIG_FILE="{{ justfile_directory() }}/files/.config/mise/config.toml" mise install --locked

# Pull changes, restow files, and install from the existing lock
update:
    git pull --ff-only
    just link
    just tools

# Intentionally advance fuzzy selectors, refresh the Linux x64 lock, and install
upgrade:
    MISE_IGNORED_CONFIG_PATHS="${HOME}/.config/mise" MISE_GLOBAL_CONFIG_FILE="{{ justfile_directory() }}/files/.config/mise/config.toml" mise lock --global --platform linux-x64 --bump
    just tools
