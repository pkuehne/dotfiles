{ lib, config, pkgs, ... }:
let
  repo = "${config.home.homeDirectory}/.config/home-manager";
  nvimDir = "${repo}/nvim";

in {

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimDir;
  home.activation.lazyRestore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x "${pkgs.neovim}/bin/nvim" ] && [ -f "${nvimDir}/lazy-lock.json" ]; then
      "${pkgs.neovim}/bin/nvim" --headless "+Lazy! restore" +qa || true
    fi
  '';

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        cargo
        fd
        fzf
        gcc
        gnumake
        go
        jq
        nodejs
        pkg-config
        ripgrep
        rustc
        tree-sitter
        unzip
        wl-clipboard
        xclip
      ];
    };
  };
}
