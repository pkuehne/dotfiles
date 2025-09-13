{ pkgs, ... }: {
  imports = [ ./zsh.nix ./p10k.nix ./nvim.nix ];

  news.display = "silent";

  home = {
    packages = with pkgs; [
      ripgrep
      dust
      zsh-powerlevel10k
      direnv
      lazygit
      python3
    ];
    stateVersion = "24.05"; # do not bump blindly
  };

  programs = {
    home-manager = { enable = true; };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    bat = { enable = true; };
    eza = { enable = true; };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    lazygit = { enable = true; };
  };
}

