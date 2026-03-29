if ! command -v rg &>/dev/null; then
  return
fi

alias grep='rg --hidden --smart-case'
