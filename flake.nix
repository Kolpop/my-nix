{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };
  outputs = { self, nixpkgs, home-manager, catppuccin, nix-flatpak, ... }@inputs: {
 
    nixosConfigurations.AZERTY = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      system = "x86_64-linux";

      modules = [
        ./configuration.nix

        nix-flatpak.nixosModules.nix-flatpak

        {
          nixpkgs.config.allowUnfree = true;
        }
  
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.boris = {
            imports = [
              catppuccin.homeManagerModules.catppuccin
              ./home-manager/home.nix
	    ];
	  };
        }
      ];
    };

  };
}
