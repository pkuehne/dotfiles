#! /bin/bash

echo "-- Checking for tmux installation"
which tmux > /dev/null 2>&1
if [[ $? -eq "1" ]]
then
  echo "?? tmux needs to be installed"
  sudo apt update && sudo apt install tmux
else
  echo "-- tmux is installed"
fi

echo "-- Installing tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm
GIT_EXIT_CODE=$?
if [[ $GIT_EXIT_CODE -eq 128 ]]; then
    GIT_EXIT_CODE=0
fi

exit $GIT_EXIT_CODE
