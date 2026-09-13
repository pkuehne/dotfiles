# After bindkey -v (031), compinit (034) and fzf-tab (035), so `**` wraps fzf-tab.
if (( $+commands[fzf] )); then
  eval "$(fzf --zsh)"
fi
