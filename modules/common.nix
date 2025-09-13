{ pkgs, agenix, ... }: {
  imports = [ ./zsh.nix ./p10k.nix ./nvim.nix ];

  news.display = "silent";

  home = {
    packages = with pkgs;
      [ direnv dust lazygit python3 ripgrep zsh-powerlevel10k ]
      ++ [ agenix.packages.${pkgs.system}.default ];
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

