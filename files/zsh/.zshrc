# ~/.zshrc - managed by ansible dotfiles
# Sources all snippets from ~/.zshrc.d/*.zsh in order.

for _f in "${HOME}/.zshrc.d/"*.zsh(N); do
  source "$_f"
done
unset _f
