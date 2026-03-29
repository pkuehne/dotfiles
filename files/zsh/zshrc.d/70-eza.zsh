if ! command -v eza &>/dev/null; then
  return
fi

alias ls='eza'
alias ll='eza -lh --git'
alias la='eza -lha --git'
alias lt='eza --tree'
