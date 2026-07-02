#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://gitea.apps.peterkuehne.com/peter/dotfiles.git"
DOTFILES_DIR="${HOME}/.config/dotfiles"

# Ensure ~/.local/bin is on PATH (pipx installs there)
export PATH="${HOME}/.local/bin:${PATH}"

# Ensure python3, pipx, and git are available
if ! command -v pipx &>/dev/null || ! command -v git &>/dev/null; then
  echo "==> Installing python3, pipx, and git"
  sudo apt-get update -qq
  sudo apt-get install -y python3 pipx git
fi

# When piped via curl | bash, BASH_SOURCE is not set — clone the repo first
if [[ -z "${BASH_SOURCE[0]:-}" || "${BASH_SOURCE[0]}" == "bash" ]]; then
  if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
    echo "==> Cloning dotfiles"
    git clone "${DOTFILES_REPO}" "${DOTFILES_DIR}"
  fi
  exec bash "${DOTFILES_DIR}/bootstrap.sh" "$@"
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install dots if not available
if ! command -v dots &>/dev/null; then
  echo "==> Installing dots"
  pipx install git+https://github.com/pkuehne/dots.git
fi

echo "==> Deploying dotfiles"
dots --repo "${DOTFILES_DIR}" apply "$@"

echo "==> Installing tools"
dots --repo "${DOTFILES_DIR}" tools install

echo "==> Cloning repos"
dots --repo "${DOTFILES_DIR}" repos clone

echo ""
echo "==> Done! To apply changes in future, run:"
echo "      exec zsh && just apply"
