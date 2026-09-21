# Dotfiles

[mise](https://mise.jdx.dev)-based dotfile and CLI tool manager. This is the
complete, public set. A private overlay repo may be layered on top of it
(see "Overlay repos" below).

## Structure

```
bootstrap.sh              # Only entry point: installs mise, seeds the conf.d link,
                          # runs `mise bootstrap`. Must be run from a clone at ~/dotfiles.
mise.toml                 # EVERYTHING: settings, tools, env, dotfiles, repos, hooks, tasks
justfile                  # Thin wrappers around mise commands

files/                    # Mirrored into $HOME by the single "~" [dotfiles] entry
  .zshenv                 # Sets ZDOTDIR; the one zsh file that cannot move
  .claude/
    settings.json         # Own entry, so an overlay can redirect it
    statusline.sh         # Extracted from settings.json so overlays duplicate less
  .config/
    bash/rc.d/            # Bash fallback fragments, sourced by the ~/.bashrc block
    bat/config
    bat/themes/           # vendored tmTheme; needs `mise run bat-cache`
    fontconfig/fonts.conf
    ghostty/config        # Tokyo Night Moon, Aurora edge glow + cursor sweep
    git/config            # ends with an optional `include local.config` for overlays
    git/ignore            # global gitignore (git's default XDG path)
    hypr/monitors.lua     # only Hyprland file that differs from Omarchy's defaults
    kitty/                # kitty.conf + tokyonight-moon.conf
    lazydocker/config.yml
    lazygit/config.yml
    nvim/                 # Full LazyVim config (starter + custom overrides)
      lua/plugins/        # colorscheme.lua sets Tokyo Night Moon
    starship.toml         # bash fallback prompt
    tmux/tmux.conf        # tmux config (Tokyo Night Moon, vi-mode, TPM plugins)
    zsh/
      .zshrc              # sources $ZDOTDIR/rc.d in strict numeric order
      .p10k.zsh           # Powerlevel10k prompt config
      rc.d/               # zsh fragments, mirroring bash/rc.d
        030-p10k-instant.zsh  # Powerlevel10k instant prompt (must be first)
        031-options.zsh       # Shell options + vi keybindings
        032-history.zsh       # History settings (HISTFILE under XDG_STATE_HOME)
        033-mise.zsh          # `mise activate` — puts all tools on PATH
        034-completion.zsh    # fpath, compinit, zstyle
        035-plugins.zsh       # Plugins (fzf-tab, p10k, autosuggestions, syntax-hl)
        036-fzf.zsh           # fzf key-bindings (eval "$(fzf --zsh)")
        037-aliases.zsh       # Tool aliases (nvim, bat, eza, lazygit, rg, tmux)
        038-zoxide.zsh        # zoxide init
        039-docker.zsh        # Docker helpers (dps, dstatus, dlog, dexec, ...)
        040-helpers.zsh       # Misc functions (reload, port, psef, help)
        041-vi-mode.zsh       # vi keymap fixes on top of bindkey -v
        042-direnv.zsh        # direnv hook
        049-p10k.zsh          # p10k config (must be last)
  .local/bin/
    rail-status           # next trains home, wired into tmux status-right. Reads an
                          # unmanaged ~/.config/rail-status.json (API key + stations)
                          # and prints nothing when absent, so it is safe on every host
  .ssh/                   # own entries in mise.personal.toml, excluded from the "~" walk
    config                # `Include config.d/*` and nothing else
    config.d/             # 10-defaults, 20-canonicalize, 30-homelab, 40-git
```

## Usage

```bash
# Fresh machine (needs git + curl). The only supported entry point.
# Clone path is mandatory; bootstrap.sh rejects anything else.
cd ~ && git clone https://github.com/pkuehne/dotfiles.git
~/dotfiles/bootstrap.sh

just                       # List recipes
just apply                 # mise bootstrap --yes
just plan                  # Show pending changes
just diff                  # Show pending dotfile changes in detail
just status                # State of every managed dotfile
just up                    # Bump pinned versions + refresh completions
```

## Overlay repos

`~/.config/mise/conf.d/*.toml` is the *global* config directory: mise loads and
merges every file in it, in alphabetical order, on every invocation from any
directory. So a second repo can layer private machine config on top of this one
by symlinking its own `mise.toml` into `conf.d` under a later-sorting name —
and a bare `mise bootstrap` then converges both in a single pass, no `-C`.

mise.toml has no `include`/`import` key; `conf.d` is the mechanism.

An overlay redirects an individual file by **naming the same target path**:
whole-file `[dotfiles]` entries merge by target path, and the later config layer
wins. That only works for files with their own entry — anything swept up by a
`symlink-each` directory walk cannot be redirected — which is why the `exclude`
list on the `"~"` entry pulls `.ssh/**` and `.claude/settings.json` out of the
walk and gives each its own entry.

For git, the overlay needs no dotfile entry at all: `files/.config/git/config`
ends with `[include] path = local.config`, a relative include that git silently
skips when absent.

## Tools installed

bat, btop, claude, cmake, delta, difftastic, direnv, duf, dust, eza, fd, fzf,
gh, go, just, lazydocker, lazygit, neovim, node, ripgrep, starship, tmux,
tree-sitter, vivid, watchexec, yq, zoxide — all pinned in `[tools]`.

`mise.personal.toml` adds `codex` on personal machines only. `[tools]` merges
additively and a later layer cannot *remove* an inherited entry, so anything a
work machine must not have has to live there rather than in `[tools]` here.

## Adding a new tool

Add a line to `[tools]` in `mise.toml`. Check availability first with
`mise registry <name>`; `mise ls-remote <name>` lists versions.

```toml
[tools]
mytool = "1.2.3"                    # registry name
"aqua:owner/repo" = "1.2.3"         # pin a specific backend
"github:owner/repo" = "1.2.3"       # not in the registry
```

Completions are NOT automatic — add the generator to the `completions` task if the tool
ships one.

## Adding a new dotfile

Place the file in `files/` mirroring its `$HOME` path. The single `"~"` entry in
`[dotfiles]` uses `symlink-each`, so new files are discovered with no config change —
but `manifest = "git"` means a new file is only linked once it is `git add`ed, and
`just link` creates the link. Give it its own entry instead if an overlay must be able
to replace it.

Shell fragments are ordinary dotfiles under that same rule: numbered `*.zsh` in
`files/.config/zsh/rc.d/` (range 030–049), numbered `*.bash` in
`files/.config/bash/rc.d/`.

## Conventions

- **One config file:** `mise.toml` is both the repo config and — via the `[dotfiles]` entry
  symlinking it to `~/.config/mise/conf.d/dotfiles.toml` — the global user config. That is
  what makes a first-run bootstrap work on a fresh machine: `bootstrap.sh` creates that
  symlink by hand before invoking mise, and the file is loaded at process start, so
  `[tools]`/`[env]` are known before the entry that globalises it has run.
- **`~/.config/mise/config.toml` is deliberately unmanaged.** It outranks `conf.d`, so it
  is the place for machine-local overrides you don't want in git.
- **The repo path `~/dotfiles` is load-bearing, not a preference.** mise does *no*
  templating on a `[dotfiles]` `source` — `{{config_root}}` and `{{env.HOME}}` both come
  through literally — and a *relative* source resolves against the config file's own
  directory without following symlinks, i.e. `~/.config/mise/conf.d/` once mise.toml is
  symlinked there. Hence absolute sources, and hence `bootstrap.sh` refuses to run from a
  clone at any other path.
- **`symlink-each`, not directory symlinks.** Several target directories hold files this
  repo doesn't own — LazyVim's `LICENSE`/`README.md`, for one.
  `symlink-each` recurses, creating real directories and symlinking only leaf files, so
  those survive. `manifest = "git"` keeps untracked strays out of the walk.
- **`[dotfiles]` edit entries are keyed `"<file>/<block-name>"`.** Undocumented and easy to
  get wrong: `"~/.bashrc/shell-d-loader"` means *block `shell-d-loader` inside `~/.bashrc`*,
  not a file called `shell-d-loader`. Used to keep Ubuntu's `~/.bashrc` unmanaged apart
  from one marked block. `~/.zshenv` used to be a block edit too, because rustup owned its
  other line; rustup is gone, so it is now an ordinary file in `files/`.
- **`~/.ssh/config` is `Include config.d/*` and nothing else,** matching the shape work
  now imposes, so both machines have one layout. Two ssh parser rules govern edits here:
  ssh takes the **first** value it obtains for a keyword, so fragment order is
  authoritative and `10-defaults.conf` must stay first; and `Host`/`Match` context carries
  **across** `Include` boundaries, so every fragment must open with an explicit `Host`
  line or it silently inherits the previous file's last stanza. A relative `Include`
  resolves against `~/.ssh`, not against the symlink target in this repo. Verify a change
  with `diff <(ssh -F old -G host) <(ssh -F new -G host)` — concatenating the fragments in
  glob order is exactly what `Include` does.
- **XDG wherever the tool allows it.** zsh via `ZDOTDIR` (set in `~/.zshenv`, the one file
  that cannot move; it also sets `skip_global_compinit=1`, which is how Ubuntu's
  `/etc/zsh/zshrc` is told not to run its own compinit before `~/.zshrc`),
  tmux at `~/.config/tmux/tmux.conf` with
  `TMUX_PLUGIN_MANAGER_PATH` pointing TPM at `~/.local/share/tmux/plugins`, zsh plugins
  under `~/.local/share/zsh/plugins`, history under `~/.local/state/zsh`, global gitignore
  at `~/.config/git/ignore`. `~/.bashrc`, `~/.ssh` and `~/.claude` have no XDG support.
- **Shell load order:** `files/.config/zsh/.zshrc` sources `$ZDOTDIR/rc.d/[0-9]*.zsh` in
  strict numeric order. `033-mise.zsh` must precede compinit (034), fzf-tab (035),
  `fzf --zsh` (036) and the `type nvim` alias guards (037), because it is what puts the
  tools on PATH.
- **zsh is primary, bash is a fallback.** `files/.config/bash/rc.d/*.bash` gives bash
  mise, starship, aliases, fzf, zoxide and direnv — enough to work in, not a second
  full configuration. Exactly one bash entry point (the `~/.bashrc` block loops over
  `rc.d` directly) so mise is activated once.
- **Both shells are laid out identically:** `files/.config/<shell>/rc.d/`, linked leaf
  by leaf via the `"~"` walk like every other dotfile. zsh's fragments used to live in a
  top-level `shell/` directory symlinked wholesale to `~/.config/shell.d`; that meant one
  rule for zsh and another for everything else, and split the zsh config across two
  places in the repo. The directory symlink did let a brand-new fragment appear without
  re-running anything — the tradeoff for dropping it is that a new fragment now needs
  `git add` plus `just link`, same as any other dotfile.
- **Tool install path:** `~/.local/share/mise/installs/<tool>/<version>/`, surfaced via
  `mise activate` and `~/.local/share/mise/shims`. `~/.local/bin` is *not* where mise puts
  tools — it holds the `mise` binary itself, `GOBIN` output, and hand-written scripts, and
  stays first on PATH via `_.path`.
- **Completions path:** `~/.local/share/zsh/completions` (on fpath in zsh/034-completion.zsh),
  regenerated by the `completions` task, which the `post-tools` bootstrap hook runs.
- **No secrets machinery.** mise supports sops-backed `[env] _.file`
  (`sops.age_key_file` defaults to `~/.config/mise/age.txt`) if it is ever wanted.
- **Aliases stay hand-written** in `zsh/037-aliases.zsh` — mise has no declarative
  per-tool alias mechanism.
- **TPM runs in `[tasks.bootstrap]`, not a hook.** `mise bootstrap` runs `mise run
  bootstrap` at step 15, after dotfiles (8) and tools (14) — TPM needs
  `~/.config/tmux/tmux.conf` and the `tmux` binary, so any earlier phase aborts the whole
  bootstrap on a fresh machine.
- **Theming:** Tokyo Night Moon across bat, fzf, ghostty, kitty, lazygit, delta, tmux,
  vivid and neovim. Dracula was dropped because it has only three greys; UI chrome needs
  a mid-tone ramp, which is why the tabline and status badges kept coming out either
  invisible or slabby. Tokyo Night Moon supplies one (`bg_dark`/`bg`/`bg_highlight`/
  `fg_gutter`/`terminal_black`/`dark3`/`comment`/`dark5`/`fg_dark`/`fg`).
- **bat is the one theme that isn't first-party.** vivid, ghostty and kitty all know
  Tokyo Night; bat ships only Catppuccin, so `files/.config/bat/themes/` vendors
  `tokyonight_moon.tmTheme` from folke/tokyonight.nvim's `extras/sublime`. bat only sees
  it once compiled, hence `[tasks.bat-cache]`, run by the `post-tools` hook and by
  `just up` — a bat upgrade invalidates the cache. delta reads bat's registry, so this
  covers `git diff` and the fzf previews too. **The theme is registered under its
  filename stem, `tokyonight_moon`, not the `TokyoNight` name inside the file**; get it
  wrong and bat silently falls back to the default with a warning on stderr.

## Sensitive files

Only public SSH material and client configuration belong here. Never add private keys,
credentials, `known_hosts`, agent/control sockets, or other secrets. Nothing employer-
specific belongs in this repo — hostnames, proxies, internal tool names and work
identities go in a private overlay.

## Validation

Do not deploy to the real home or install tools merely to test a change. Use
`mise bootstrap --dry-run`, `mise bootstrap dotfiles diff`, and an isolated temporary
`HOME`, `XDG_CONFIG_HOME`, `MISE_DATA_DIR` and `MISE_STATE_DIR` for apply tests.
