{ config, pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
    	{ name = "fzf-tab"; src = pkgs.zsh-fzf-tab; }
    ];

    initContent = lib.mkMerge [

    (lib.mkOrder 550 ''
      export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      P10K_DIR="$HOME/.nix-profile/share/zsh-powerlevel10k"
      source "$P10K_DIR/powerlevel10k.zsh-theme"
    '')

    # (lib.mkOrder 560 ''
    #   P10K_DIR="$HOME/.nix-profile/share/zsh-powerlevel10k"
    #   source "$P10K_DIR/config/p10k-lean.zsh"
    # '')

    ''
      PROMPT='%n@%m %1~ %# '

      # History
      HISTFILE=$HOME/.zsh_history
      HISTSIZE=50000
      SAVEHIST=50000
      setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_REDUCE_BLANKS

      # Keybindings
      bindkey -e
      bindkey '^R' history-incremental-search-backward

      # Aliases
      export EDITOR=nvim
      alias grep='rg --hidden --smart-case'
      alias ll='eza -lh --git'
      alias la='eza -lha --git'
      alias cat='bat --paging=never'

      # fzf defaults
      export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
      [[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
    ''
    ];
  };
}

