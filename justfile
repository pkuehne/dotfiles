# Dotfiles manager
# Usage: just [recipe] [args]

# List available recipes
help:
    just --list

# Deploy files and clone repos
run *args:
    dots --repo {{justfile_directory()}} apply {{args}}

# Dry-run showing what would change
check *args:
    dots --repo {{justfile_directory()}} preview {{args}}

# Install configured tools
tools *args:
    dots --repo {{justfile_directory()}} tools install {{args}}

# Show deployment status
status:
    dots --repo {{justfile_directory()}} status

# Pull latest changes and apply
update:
    git pull
    just run
    @echo "Done! Run: source ~/.zshrc"

# Upgrade dots itself, then update
upgrade:
    pipx install --force git+https://github.com/pkuehne/dots.git
    just update
