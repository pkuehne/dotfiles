# peter.fan

A bar widget for fan speed and thermal profile. Icon-only in the bar, spinning
while the fans are actually moving air; the popup shows per-fan rpm, the
temperatures the same driver reports, and a button for every ACPI platform
profile the firmware exposes.

```
manifest.json               plugin metadata + settings schema
Panel.qml                   bar button and popup
Model.js                    sysfs vocabulary → labels, icons, spin timing
fanctl                      sysfs read/write helper
install.sh                  udev rule + bar registration
90-platform-profile.rules   the udev rule itself
```

## Install

```bash
~/.config/omarchy/plugins/peter.fan/install.sh
```

It installs a udev rule (one `sudo` prompt), reloads udev, and adds the widget
to the bar. Both steps are idempotent and skipped if already done;
`install.sh --uninstall` reverses them.

Omarchy has no install-hook mechanism to do this automatically, and that is
deliberate — `omarchy plugin add` clones arbitrary git repos, so running their
scripts as root would be a supply-chain hole. Upstream is explicit that the
installer "never runs plugin code, install hooks, or sudo". Anything privileged
is therefore a script the user runs knowingly, which is what this is.

Without the rule the widget still reads fine; it says so on the buttons rather
than failing silently.

Check the write path without the UI:

```bash
./fanctl sensors        # includes `writable 1` once the rule is live
./fanctl set quiet
```

## Why not power-profiles-daemon

ppd is running on this machine and does drive `platform_profile`, but it maps
the firmware's six profiles onto three of its own. Going through it would make
`cool`, `balanced-performance` and `custom` unreachable, so this writes the
sysfs attribute directly.

The tradeoff is that ppd does not know about those writes:

- `powerprofilesctl` reports whichever of its three profiles it last set, which
  may no longer match what this widget shows. The widget re-reads sysfs, so the
  widget is the one telling the truth.
- Omarchy's battery service calls `omarchy-powerprofiles-set` on every AC
  plug/unplug, which pushes a ppd profile and overwrites the choice made here.
  Disable the `omarchy.battery` plugin if that becomes annoying.

Neither this widget nor ppd makes a profile survive a reboot on its own.

## Tracked in dotfiles

The real files live in `~/dotfiles/files/.config/omarchy/plugins/peter.fan/` and
are symlinked here by the single `"~"` entry in `mise.toml`. Because that entry
is `symlink-each`, only these leaf files are linked — the rest of
`~/.config/omarchy/` (`shell.json`, `themes/`, `hooks/`) stays real and
unmanaged.

**Editing the repo copy does not hot-reload.** The shell watches the plugin
directory with `inotifywait -m -r`, which sees writes to files inside it; a
write to a symlink's target somewhere else fires no event. After editing in the
repo:

```bash
omarchy-shell shell rescanPlugins
```

A new file also needs `git add` before `just link` will link it, since the `"~"`
entry uses `manifest = "git"`.

## Notes

- The write targets `/sys/class/platform-profile/*/profile`, not the legacy
  `/sys/firmware/acpi/platform_profile`. They are separate inodes and udev can
  only reach the former; `fanctl` falls back to the legacy path on older
  kernels, where the rule will not help and root is required.
- Several drivers can front the same physical fans — on this machine
  `alienware_wmi`, `dell_ddv` and `dell_smm` all report the same two. `fanctl`
  scores them and prefers the one that labels its fans and publishes a ceiling.
- Only labelled temperatures are shown. `dell_ddv` exposes nine unlabelled
  sensors, which is noise in a popup this size.
