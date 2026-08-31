#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://gitea.apps.peterkuehne.com/peter/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-${HOME}/dotfiles}"

run_as_root() {
  if [[ ${EUID} -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

install_prerequisites() {
  # shellcheck disable=SC1091
  source /etc/os-release

  case "${ID}:${ID_LIKE:-}" in
    arch:*|cachyos:*|*:*arch*)
      run_as_root pacman -S --needed --noconfirm git stow mise
      ;;
    debian:*|ubuntu:*|*:*debian*|*:*ubuntu*)
      run_as_root apt-get update
      run_as_root apt-get install -y git stow

      if ! command -v mise >/dev/null 2>&1; then
        if command -v curl >/dev/null 2>&1; then
          curl -fsSL https://mise.run | sh
        elif command -v wget >/dev/null 2>&1; then
          wget -qO- https://mise.run | sh
        else
          echo "curl or wget is required to install mise" >&2
          exit 1
        fi
      fi
      ;;
    *)
      echo "Unsupported Linux distribution: ${ID:-unknown}" >&2
      echo "Install git, GNU Stow, and mise, then rerun this script." >&2
      exit 1
      ;;
  esac
}

if ! command -v git >/dev/null 2>&1 ||
  ! command -v stow >/dev/null 2>&1 ||
  ! command -v mise >/dev/null 2>&1; then
  install_prerequisites
fi

export PATH="${HOME}/.local/bin:${PATH}"

if [[ -n ${BASH_SOURCE[0]:-} && ${BASH_SOURCE[0]} != bash ]]; then
  DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [[ ! -d ${DOTFILES_DIR}/.git ]]; then
  if [[ -e ${DOTFILES_DIR} ]]; then
    echo "Cannot clone: ${DOTFILES_DIR} exists and is not a Git checkout" >&2
    exit 1
  fi
  git clone "${DOTFILES_REPO}" "${DOTFILES_DIR}"
fi

printf '\nDotfiles are ready in %s. Run:\n\n' "${DOTFILES_DIR}"
echo "  cd \"${DOTFILES_DIR}\""
echo "  mise x just@latest -- just setup"
