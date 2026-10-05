if [[ $TTY != /dev/tty1 ]]; then
  [[ -f ${ZDOTDIR:-$HOME}/.p10k.zsh ]] && source ${ZDOTDIR:-$HOME}/.p10k.zsh
fi
