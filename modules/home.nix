{ ... }: {
  imports = [ ./git.nix ];

  programs = {
    zsh = {
      shellAliases = {
        hms = "home-manager switch --flake ~/.config/home-manager#home";
      };
    };
  };
}

