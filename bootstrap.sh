#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${DOTFILES_DIR}/.venv"

echo "==> Ensuring Python venv at ${VENV_DIR}"
if [[ ! -x "${VENV_DIR}/bin/python" ]]; then
  python3 -m venv "${VENV_DIR}"
fi

echo "==> Installing/upgrading ansible"
"${VENV_DIR}/bin/pip" install --quiet --upgrade pip
"${VENV_DIR}/bin/pip" install --quiet --upgrade ansible

echo "==> Running playbook"
"${VENV_DIR}/bin/ansible-playbook" \
  --ask-become-pass \
  -i "${DOTFILES_DIR}/inventory/localhost.yml" \
  "${DOTFILES_DIR}/site.yml" \
  "$@"
