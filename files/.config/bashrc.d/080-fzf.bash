has_tool fzf || return 0

# Omarchy (and other host baselines) may have already loaded FZF's bindings.
# Its key-bindings script defines this function, as does `fzf --bash`.
declare -F fzf-file-widget >/dev/null || eval "$(fzf --bash)"

export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border=rounded --info=inline --bind=alt-p:toggle-preview'
export FZF_CTRL_R_OPTS="--preview='printf %s {}' --preview-window=down:3:wrap --sort --exact"

has_tool fd && {
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
}

has_tool bat && {
  export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers --line-range=:50 {}' --preview-window=right:55%"
}

has_tool eza && {
  export FZF_ALT_C_OPTS="--preview='eza --tree --color=always --level=2 {}' --preview-window=right:45%"
}
