{ config, lib, pkgs, ... }:
let
  repo = "${config.home.homeDirectory}/.config/home-manager";
  nvimDir = "${repo}/nvim"; 
in {
  imports = [ ./zsh.nix ./p10k.nix ];

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

    xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink nvimDir;
    home.activation.lazyRestore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -x "${pkgs.neovim}/bin/nvim" ] && [ -f "${nvimDir}/lazy-lock.json" ]; then
        "${pkgs.neovim}/bin/nvim" --headless "+Lazy! restore" +qa || true
      fi
    '';

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
      extraPackages = with pkgs; [ cargo fd fzf gcc gnumake go jq nodejs pkg-config ripgrep rustc tree-sitter unzip wl-clipboard xclip ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    lazygit = {
      enable = true;
    };
  };
}

