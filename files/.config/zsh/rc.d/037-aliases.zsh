if (( $+commands[nvim] )); then
  alias vim='nvim'
  alias vimdiff="nvim -d"
fi

if (( $+commands[bat] )); then
  alias cat='bat'
fi

if (( $+commands[eza] )); then
  alias ls='eza --grid --icons=auto --group-directories-first --time-style=long-iso'
  alias la='ls --all'
  alias ll='eza --long --header --git --no-quotes --icons=auto --group-directories-first --time-style=long-iso'
  alias lla='ll --all'
  alias lt='eza --tree --level=2 --git-ignore --icons=auto'
  alias lta='lt --all'
fi

if (( $+commands[lazygit] )); then
  alias lg='lazygit'
fi

alias grep='grep --color=auto'
