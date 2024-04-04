{
  description = "Nixos config flake";

  inputs = {

    # Default Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Allows home customisation
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
 
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      #specialArgs = {inherit inputs;};
      specialArgs = {
        home-manager = inputs.home-manager;
        rose-pine-hyprcursor = inputs.rose-pine-hyprcursor;
        nix-flatpak = inputs.nix-flatpak;
      };
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };
  };
}

