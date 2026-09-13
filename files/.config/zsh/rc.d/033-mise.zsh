# Must precede compinit (034), fzf-tab (035), `fzf --zsh` (036) and the alias
# guards (037) — this is what puts [tools] on PATH and exports [env]. Use
# Mise's installation path directly: login shells can reset PATH after zshenv.
if [[ -x "$HOME/.local/bin/mise" ]]; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$("$HOME/.local/bin/mise" activate zsh)"
  elif [ -n "${BASH_VERSION:-}" ]; then
    eval "$("$HOME/.local/bin/mise" activate bash)"
  fi
elif command -v mise >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(mise activate zsh)"
  elif [ -n "${BASH_VERSION:-}" ]; then
    eval "$(mise activate bash)"
  fi
fi
