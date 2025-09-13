{
  description = "Home Manager configuration of peter";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { nixpkgs, home-manager, agenix, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkUser = username: extraModules:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit agenix; };
          modules = [
            agenix.homeManagerModules.default
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
