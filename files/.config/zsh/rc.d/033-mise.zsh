# Must precede compinit (034), fzf-tab (035), `fzf --zsh` (036) and the alias
# guards (037) — this is what puts [tools] on PATH and exports [env]. Use
# Mise's installation path directly: login shells can reset PATH after zshenv.
if (( $+commands[mise] )); then
    eval "$(mise activate zsh)"
fi
