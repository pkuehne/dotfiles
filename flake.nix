{
  description = "Home Manager configuration of peter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkUser = username: extraModules:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./modules/common.nix
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }
          ] ++ extraModules;
        };
    in {
      homeConfigurations = {
        home = mkUser "peter" [ ./modules/home.nix ];
        work = mkUser "pkuhne1" [ ./modules/work.nix ];
      };
    };
}
