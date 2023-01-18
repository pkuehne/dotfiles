#! /bin/bash

# Run again when plugins have changed:
# {{ include "private_dot_config/nvim/lua/plugins.lua" | sha256sum }}
echo "-- Updating neovim plugins"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
