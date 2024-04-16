{
  description = "Nixos config flake";

  inputs = {

    # Default Packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Allows home customisation
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
 
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, ... }@inputs:
    let 
      system = "x86_64-linux";
      lib = inputs.nixpkgs-unstable.lib;
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
      pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};

      home-manager = inputs.home-manager;
      rose-pine-hyprcursor = inputs.rose-pine-hyprcursor;
      nix-flatpak = inputs.nix-flatpak;
    in {

      nixosConfigurations.default = lib.nixosSystem {

        specialArgs = {
          inherit home-manager;
          inherit rose-pine-hyprcursor;
          inherit nix-flatpak;
          inherit pkgs-stable;
          inherit pkgs-unstable;
        };

        inherit system;

        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
  }

