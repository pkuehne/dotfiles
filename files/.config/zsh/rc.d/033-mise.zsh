# Must precede compinit (034), fzf-tab (035), `fzf --zsh` (036) and the alias
# guards (037) — this is what puts [tools] on PATH and exports [env].
#
# Re-assert mise's default install dir: .zshenv adds it, but a login shell can
# reset PATH after zshenv. mise is then found by name rather than at a fixed
# path, so a system-packaged one (termux) is picked up instead.
typeset -U path
path=("$HOME/.local/bin" $path)

if (( $+commands[mise] )); then
    eval "$(mise activate zsh)"
fi
