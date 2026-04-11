# Dotfiles manager
# Usage: just [recipe] [args]

# Deploy files, install tools, and clone repos
run *args:
    dots --repo {{justfile_directory()}} apply {{args}}
    dots --repo {{justfile_directory()}} tools install
    dots --repo {{justfile_directory()}} repos clone

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
