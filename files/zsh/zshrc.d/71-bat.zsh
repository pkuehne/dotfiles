if ! command -v bat &>/dev/null; then
  return
fi

alias cat='bat --paging=never'
