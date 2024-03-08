#############################################################
# This file is managed by chezmoi, don't edit it directly !!!
#############################################################

# Use neovim instead of vim
if type nvim &> /dev/null; then
  alias vim='nvim'
fi

# Use bat instead of cat
if type bat &> /dev/null; then
  alias cat='bat'
fi

if type exa &> /dev/null; then
  alias ls='exa --grid --time-style=long-iso --icons'
  alias ll='ls --long'
  alias ll='ls --long --all'
  alias lg='ls --long --git'
  alias tree='exa --tree'
fi

if type rg &> /dev/null; then
  alias grep='rg'
fi

# Always enable Unicode and 256 colours
alias tmux="tmux -u -2"
