# Loaded after plugins (035) and fzf (036) so these land on top of theirs.

# Lag between ESC and vicmd. Default is 40, i.e. 400ms.
KEYTIMEOUT=1

# bindkey -v (031) installs vi-* variants that refuse to edit back past the
# point insert mode started, and leaves ^A/^E/^K as self-insert.
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line

# ^X^E as in bash. vicmd v stays visual-mode, which p10k already shows as V.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^X^E' edit-command-line
bindkey -M vicmd '^X^E' edit-command-line

# Steady block in command mode, steady bar in insert. Hooks rather than plain
# widget definitions, so p10k's own zle-line-init survives.
autoload -Uz add-zle-hook-widget
_vi_cursor() {
  case $KEYMAP in
    (vicmd|visual) print -n '\e[2 q' ;;
    (*)            print -n '\e[6 q' ;;
  esac
}
_vi_cursor_bar() { print -n '\e[6 q' }
add-zle-hook-widget zle-keymap-select _vi_cursor
add-zle-hook-widget zle-line-init     _vi_cursor
add-zle-hook-widget zle-line-finish   _vi_cursor_bar
