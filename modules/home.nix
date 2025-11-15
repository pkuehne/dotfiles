{ pkgs, ... }: {
  imports = [ ./git.nix ./ssh.nix ];

  home.packages = with pkgs; [ krb5 ];

  programs = {
    zsh = {
      shellAliases = {
        hms = "home-manager switch --flake ~/.config/home-manager#home";
      };
    };
  };
}

