# fzf shell integration and configuration

if ! command -v fzf &>/dev/null; then
  return
fi

# Shell key bindings (CTRL-R history, CTRL-T files, ALT-C dirs)
eval "$(fzf --zsh)"

# ── Backend ───────────────────────────────────────────────────────────────────
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# ── Appearance ────────────────────────────────────────────────────────────────
# Dracula colours + tmux popup when inside tmux, inline otherwise
if [[ -n "${TMUX:-}" ]]; then
  _fzf_display="--tmux=60%"
else
  _fzf_display="--height=40%"
fi

export FZF_DEFAULT_OPTS="${_fzf_display} \
  --layout=reverse \
  --border=rounded \
  --info=inline \
  --bind=alt-p:toggle-preview \
  --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
  --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
  --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
  --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
unset _fzf_display

# ── CTRL-T: file search with bat preview ─────────────────────────────────────
if command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers --line-range=:50 {}' --preview-window=right:55%"
fi

# ── ALT-C: directory jump with eza tree preview ───────────────────────────────
if command -v eza &>/dev/null; then
  export FZF_ALT_C_OPTS="--preview='eza --tree --color=always --level=2 {}' --preview-window=right:45%"
fi

# ── CTRL-R: history search ────────────────────────────────────────────────────
export FZF_CTRL_R_OPTS="--preview='echo {}' --preview-window=down:3:wrap --sort --exact"
