{ config, pkgs, ... }:
{
  imports = [ ./zsh.nix ./p10k.nix ];

  home = {
    packages = with pkgs; [
      ripgrep
      dust
      zsh-powerlevel10k
    ];
    stateVersion = "24.05"; # do not bump blindly
  };

  programs = {
    home-manager = {
      enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    bat = {
      enable = true;
    };
    eza = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}

