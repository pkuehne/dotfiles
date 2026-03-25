# Zsh plugins
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
source "${HOME}/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme"

source "${HOME}/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history)

[[ -f "${HOME}/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" ]] && \
  source "${HOME}/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

source "${HOME}/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
