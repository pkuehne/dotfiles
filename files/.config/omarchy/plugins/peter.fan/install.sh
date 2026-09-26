#!/usr/bin/env bash
# install.sh — one-time setup for the peter.fan widget.
#
# Omarchy's plugin installer deliberately never runs plugin code, install hooks
# or sudo: `omarchy plugin add` clones arbitrary git repos, so running their
# scripts as root would be a supply-chain hole. Anything privileged is therefore
# a step the user runs knowingly, and this is that step.
#
#   1. install a udev rule granting `wheel` write access to the ACPI platform
#      profile, so the widget can switch profiles with no password prompt
#   2. register the plugin with the running shell and put it on the bar
#
# Both steps are idempotent and each is skipped if already done.
# Run with --uninstall to reverse both.

set -euo pipefail

# Resolve the directory this was invoked through, without following the script
# symlink: when the plugin is tracked in a dotfiles repo, the leaf files are
# symlinks but the plugin directory itself is real, and that is the one we want.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULE_NAME="90-platform-profile.rules"
RULE_SRC="$SCRIPT_DIR/$RULE_NAME"
RULE_DEST="/etc/udev/rules.d/$RULE_NAME"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; }
die()  { printf '\033[31mfatal:\033[0m %s\n' "$*" >&2; exit 1; }

plugin_id() {
  if command -v jq >/dev/null 2>&1 && [[ -r "$SCRIPT_DIR/manifest.json" ]]; then
    jq -r '.id' "$SCRIPT_DIR/manifest.json"
  else
    echo "peter.fan"
  fi
}

profile_file() {
  local f
  for f in /sys/class/platform-profile/*/profile; do
    [[ -e $f ]] && { printf '%s' "$f"; return 0; }
  done
  return 1
}

writable_now() {
  local f
  f=$(profile_file) || return 1
  [[ -w $f ]]
}

# ------------------------------------------------------------------- install

do_install() {
  local id pf
  id=$(plugin_id)
  bold "Installing $id"

  if ! pf=$(profile_file); then
    # The legacy /sys/firmware/acpi/platform_profile is a different inode that
    # udev cannot reach, so the rule genuinely cannot help there.
    die "no /sys/class/platform-profile device on this kernel — the udev rule cannot grant access; fanctl would need root"
  fi
  ok "found platform profile device: $pf"

  if writable_now; then
    ok "already writable — skipping udev rule"
  else
    [[ -r $RULE_SRC ]] || die "missing $RULE_NAME next to this script"
    bold "Installing udev rule (needs sudo)"
    sudo install -m 0644 "$RULE_SRC" "$RULE_DEST"
    sudo udevadm control --reload
    sudo udevadm trigger --subsystem-match=platform-profile
    # The trigger is asynchronous; give the RUN+= chgrp/chmod a moment to land.
    sudo udevadm settle --timeout=5 || true
    if writable_now; then
      ok "udev rule installed, profile is now writable"
    else
      warn "rule installed but the profile is still read-only"
      warn "check: id -nG | grep wheel   and   ls -l $pf"
    fi
  fi

  if command -v omarchy-shell >/dev/null 2>&1 && omarchy-shell shell ping >/dev/null 2>&1; then
    omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
    ok "shell rescanned"
    if omarchy-shell shell listPlugins 2>/dev/null | grep -q "\"$id\""; then
      omarchy-shell shell setPluginEnabled "$id" true >/dev/null 2>&1 || true
      ok "enabled $id on the bar"
    else
      warn "$id not discovered — is it in ~/.config/omarchy/plugins/?"
    fi
  else
    warn "omarchy-shell is not running; start it and run: omarchy plugin enable $id"
  fi

  bold "Done"
  "$SCRIPT_DIR/fanctl" sensors | sed 's/^/  /'
}

# ----------------------------------------------------------------- uninstall

do_uninstall() {
  local id
  id=$(plugin_id)
  bold "Removing $id"

  if command -v omarchy-shell >/dev/null 2>&1 && omarchy-shell shell ping >/dev/null 2>&1; then
    omarchy-shell shell setPluginEnabled "$id" false >/dev/null 2>&1 || true
    ok "removed from the bar"
  fi

  if [[ -e $RULE_DEST ]]; then
    bold "Removing udev rule (needs sudo)"
    sudo rm -f "$RULE_DEST"
    sudo udevadm control --reload
    # Permissions set by RUN+= persist on the live device until it is re-added,
    # so re-trigger to put the profile back under root ownership.
    sudo udevadm trigger --subsystem-match=platform-profile
    ok "udev rule removed"
  else
    ok "no udev rule installed"
  fi

  bold "Done — the plugin directory itself was left in place"
}

case "${1:-install}" in
  install | "")          do_install ;;
  --uninstall | uninstall) do_uninstall ;;
  -h | --help)
    echo "Usage: install.sh [--uninstall]"
    ;;
  *) die "unknown argument: $1" ;;
esac
