{ ... }: {
  imports = [ ./git.nix ./ssh.nix ];

  programs = {
    zsh = {
      shellAliases = {
        hms = "home-manager switch --flake ~/.config/home-manager#home";
      };
    };
  };
}

