# Dotfiles playbook runner
# Usage: just [recipe] [args]

venv := ".venv/bin/ansible-playbook"
inventory := "inventory/localhost.yml"
playbook := "site.yml"

# Run the full playbook
run *args:
    {{venv}} -i {{inventory}} {{playbook}} {{args}}

# Dry-run showing what would change
check *args:
    {{venv}} -i {{inventory}} {{playbook}} --check --diff {{args}}

# Run a specific role by tag (e.g. just role zsh)
role tag *args:
    {{venv}} -i {{inventory}} {{playbook}} --tags {{tag}} {{args}}

# Force reinstall all tools and nvim (picks up new versions)
upgrade *args:
    {{venv}} -i {{inventory}} {{playbook}} --tags tools,nvim -e force_reinstall=true {{args}}

# List available tags
tags:
    {{venv}} -i {{inventory}} {{playbook}} --list-tags
