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
sudo install -m 0644 "$here/90-platform-profile.rules" /etc/udev/rules.d/
sudo udevadm control --reload
sudo udevadm trigger --subsystem-match=platform-profile
systemctl --user enable --now gnome-keyring-daemon.socket tailscale-systray.service
