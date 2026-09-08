# Thin wrappers around mise — everything real is declared in mise.toml.
# No -C: every config in ~/.config/mise/conf.d is global, so a bare
# `mise bootstrap` converges this repo and any overlay layered on top of it.
default: help

help:
  just --list

# Install mise itself
install:
  curl -fsSL https://mise.run | sh
  mise --version

# Deploy everything: dotfiles, plugin repos, tools, completions
apply:
  mise bootstrap --yes

# Show what `just apply` would change, without changing anything
plan:
  mise bootstrap plan

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
