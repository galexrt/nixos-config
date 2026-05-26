{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.11";
    };
    nixos-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-master = {
      url = "github:NixOS/nixpkgs/master";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixcord
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chiri
    chiri = {
      url = "github:SapphoSys/chiri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Antec Flux Pro Display
    antec-flux-pro-display = {
      url = "github:galexrt/antec-flux-pro-display/feat/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    allowUnfree = true;
  };

  outputs = {
    self,
    nixpkgs,
    nixos-unstable,
    nixos-hardware,
    nixpkgs-master,
    sops-nix,
    home-manager,
    chiri,
    antec-flux-pro-display,
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
          ./hosts/finka
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
          ./hosts/moira
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
          inputs.antec-flux-pro-display.nixosModules.default

          ./base.nix
          ./hosts/reaper
        ];

        specialArgs = {
          inherit inputs nixos-hardware;
          nixos-unstable = inputs.nixos-unstable.legacyPackages.x86_64-linux;
          nixpkgs-master = inputs.nixpkgs-master.legacyPackages.x86_64-linux;
        };
      };

      # Desktop
      ana = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          ./base.nix
          ./hosts/ana
        ];

        specialArgs = {
          inherit inputs nixos-hardware;
          nixos-unstable = inputs.nixos-unstable.legacyPackages.x86_64-linux;
        };
      };
    };
  };
}
