#! /bin/bash

echo "-- Checking for neovim installation"
which nvim > /dev/null 2>&1
if [[ $? -eq "1" ]]
then
  echo "?? neovim needs to be installed"
  sudo add-apt-repository ppa:neovim-ppa/stable
  sudo apt update && sudo apt install -y neovim
else
  echo "-- neovim is installed"
fi

echo "-- Installing neovim plugin manager"
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
   "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"

echo "-- Updating neovim plugins"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
