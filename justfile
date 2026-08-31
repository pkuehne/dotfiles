set shell := ["bash", "-euo", "pipefail", "-c"]

default: help

# List available recipes
help:
    @just --list

# Preview all bootstrap changes without applying them
check:
    mise bootstrap --dry-run

# Show the state of managed repositories, dotfiles, and tools
status:
    mise bootstrap status

# Converge the complete workstation using the committed lockfile
apply:
    mise bootstrap --yes --locked

# Reapply only the managed dotfile links
reapply:
    mise bootstrap dotfiles apply --yes

# Update this checkout and managed repositories, then converge the workstation
update:
    git pull --ff-only
    mise bootstrap --update --yes --locked

# Apply a named Mise configuration environment, such as `just profile work`
profile environment:
    mise bootstrap -E {{environment}} --yes --locked

# Intentionally refresh the Linux x64 tool lockfile, then install it
upgrade:
    mise lock --global --platform linux-x64 --bump
    mise bootstrap --yes --locked
