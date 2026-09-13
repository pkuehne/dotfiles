# Numeric order is load-bearing: 030 sets the p10k instant prompt, and 032/033
# put Mise and its tools on PATH for compinit (034), fzf-tab (035) and alias
# guards (037).

for _f in ${ZDOTDIR:-$HOME/.config/zsh}/rc.d/[0-9]*.zsh(N); do
  source "$_f"
done
unset _f
