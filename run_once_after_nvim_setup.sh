#! /bin/bash

echo "-- Checking for nvim installation"
which nvim > /dev/null 2>&1
if [[ $? -eq "1" ]]
then
  echo "?? nvim needs to be installed"
  sudo apt update && sudo apt install nvim
else
  echo "-- nvim is installed"
fi

echo "-- Installing nvim plugin manager"
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
   "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"

echo "-- Installing nvim plugins"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
