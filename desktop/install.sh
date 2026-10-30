#!/usr/bin/env bash
# Laptop-only desktop: the Hyprland session, titan's dependencies and their services.
set -euo pipefail

here=$(dirname "$(readlink -f "$0")")
launcher="$here/../files/.config/quickshell/titan/launcher/install"

mapfile -t packages < "$here/packages.txt"
sudo pacman -S --needed "${packages[@]}"
"$launcher/1password.sh"

sudo systemctl enable --now bluetooth NetworkManager tailscaled
sudo systemctl enable linux-modules-cleanup
systemctl --user enable --now gnome-keyring-daemon.socket
