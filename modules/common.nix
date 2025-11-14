{ pkgs, agenix, ... }: {
  imports = [ ./zsh.nix ./p10k.nix ./nvim.nix ./tmux.nix ];

  news.display = "silent";

  home = {
    packages = with pkgs;
      [
        direnv
        dust
        lazygit
        python3
        ripgrep
        zsh-powerlevel10k
        wl-clipboard
        statix
        alejandra
        nixd
        nil
      ] ++ [ agenix.packages.${pkgs.system}.default ];
    stateVersion = "24.05"; # do not bump blindly
    sessionVariables = {
      WAYLAND_DISPLAY = "wayland-0";
      XDG_RUNTIME_DIR = if builtins.pathExists "/mnt/wslg/runtime-dir" then
        "/mnt/wslg/runtime-dir"
      else
        "/run/user/1000";
    };
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

