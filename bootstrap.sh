#!/bin/sh
#   cd ~ && git clone https://github.com/pkuehne/dotfiles.git
#   ~/dotfiles/bootstrap.sh
set -eu

DOTFILES_DIR="${HOME}/dotfiles"
PROFILE="${1:-minimal}"

# mise.toml's [dotfiles] sources are absolute paths under $DOTFILES_DIR, and have
# to be: mise does no templating on a dotfile `source`, and a relative one resolves
# against ~/.config/mise/conf.d/ once mise.toml is symlinked there.
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
if [ "$HERE" != "$(CDPATH= cd -- "$DOTFILES_DIR" 2>/dev/null && pwd -P)" ]; then
    echo "ERROR: clone this repo to $DOTFILES_DIR (running from $HERE)" >&2
    exit 1
fi

if ! command -v mise >/dev/null 2>&1; then
    echo "==> Installing mise..."
    curl -fsSL https://mise.run | sh
fi
PATH="${HOME}/.local/bin:${PATH}"; export PATH

# Seed the conf.d links before mise starts. Config is read at process start, so
# [tools]/[env]/[dotfiles] are all known on this first run; the [dotfiles] entries
# then re-assert the same links idempotently.
#
# personal.toml carries the machine-specific bits (ssh) that must not reach a
# work machine. Run this script only on a personal box; a work machine has its
# own bootstrap, which links a private overlay instead.
mkdir -p "${HOME}/.config/mise/conf.d"
ln -sfn "${DOTFILES_DIR}/mise.toml"          "${HOME}/.config/mise/conf.d/dotfiles.toml"
ln -sfn "${DOTFILES_DIR}/mise.personal.toml" "${HOME}/.config/mise/conf.d/personal.toml"

# The base config is deliberately lightweight. A full workstation adds the
# language runtimes and development-only tools through a separate mise layer.
FULL_CONFIG="${HOME}/.config/mise/conf.d/dotfiles-full.toml"
case "$PROFILE" in
    minimal)
        if [ -e "$FULL_CONFIG" ] || [ -L "$FULL_CONFIG" ]; then
            if [ "$(readlink "$FULL_CONFIG" 2>/dev/null || true)" = "${DOTFILES_DIR}/mise.full.toml" ]; then
                rm -f "$FULL_CONFIG"
            else
                echo "ERROR: refusing to replace unmanaged $FULL_CONFIG" >&2
                exit 1
            fi
        fi
        ;;
    full)
        ln -sfn "${DOTFILES_DIR}/mise.full.toml" "$FULL_CONFIG"
        ;;
    *)
        echo "Usage: $0 [minimal|full]" >&2
        exit 2
        ;;
esac

echo "==> Running mise bootstrap ($PROFILE profile)..."
mise trust "$DOTFILES_DIR"
mise bootstrap --yes

echo "==> Done! Restart your shell to pick up all changes."
