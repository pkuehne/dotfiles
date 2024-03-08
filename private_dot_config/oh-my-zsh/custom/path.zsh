#############################################################
# This file is managed by chezmoi, don't edit it directly !!!
#############################################################

path+=("${HOME}/bin")
path+=("${HOME}/.local/bin")
if [[ -d "${HOME}/.cargo/bin" ]]; then
  path+=("${HOME}/.cargo/bin")
fi
