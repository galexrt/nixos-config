{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    nixos-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  nixConfig = {
    allowUnfree = true;
  };

  outputs = {
    self,
    nixpkgs,
    nixos-unstable,
    sops-nix,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: {
    nixosConfigurations = {
      # Laptop
      finka = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          ./base.nix
          ./machines/finka
        ];
        specialArgs = {
          inherit inputs nixos-hardware;
          nixos-unstable = inputs.nixos-unstable.legacyPackages.x86_64-linux;
        };
      };

      # Laptop
      moira = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          ./base.nix
          ./machines/moira
        ];
        specialArgs = {
          inherit inputs nixos-hardware;
          nixos-unstable = inputs.nixos-unstable.legacyPackages.x86_64-linux;
        };
      };

      # Workstation
      reaper = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          ./base.nix
          ./machines/reaper
        ];

        specialArgs = {
          inherit inputs nixos-hardware;
          nixos-unstable = inputs.nixos-unstable.legacyPackages.x86_64-linux;
        };
      };

      # Desktop
      ana = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          ./base.nix
          ./machines/ana
        ];

        specialArgs = {
          inherit inputs nixos-hardware;
          nixos-unstable = inputs.nixos-unstable.legacyPackages.x86_64-linux;
        };
      };
    };
  };
}
