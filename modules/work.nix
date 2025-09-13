{ ... }: {
  programs = {
    zsh = {
      shellAliases = {
        hms = "home-manager switch --flake ~/.config/home-manager#work";
      };
    };
  };
}

