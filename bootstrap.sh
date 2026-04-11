#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install dots if not available
if ! command -v dots &>/dev/null; then
  echo "==> Installing dots"
  python3 -m pip install --user git+https://github.com/peterkuehne/dots.git
fi

echo "==> Deploying dotfiles"
dots --repo "${DOTFILES_DIR}" apply "$@"

echo "==> Installing tools"
dots --repo "${DOTFILES_DIR}" tools install

echo "==> Cloning repos"
dots --repo "${DOTFILES_DIR}" repos clone

echo ""
echo "==> Done! To apply changes in future, run:"
echo "      exec zsh && just run"
