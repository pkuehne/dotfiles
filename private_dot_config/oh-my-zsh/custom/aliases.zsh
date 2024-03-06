#############################################################
# This file is managed by chezmoi, don't edit it directly !!!
#############################################################

# Use neovim instead of vim
if type nvim &> /dev/null; then
  alias vim='nvim'
fi

# Always enable Unicode and 256 colours
alias tmux="tmux -u -2"
