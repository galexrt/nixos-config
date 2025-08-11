{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
      config.allowUnfree = true;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, home-manager }: {
    nixosConfigurations = {
      finka = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          ./base.nix
          ./machines/finka
        ];
      };

      moira = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          ./base.nix
          ./machines/moira
        ];
      };

      reaper = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          ./base.nix
          ./machines/reaper
        ];
      };
    };
  };
}
