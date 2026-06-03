{
  inputs = {
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems = {
      url = "github:nix-systems/default";
    };

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };
    nixos-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-master = {
      url = "github:NixOS/nixpkgs/master";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
      url = "github:galexrt/chiri";
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

  outputs =
    {
      self,
      disko,
      nixpkgs,
      systems,
      treefmt-nix,
      nixos-unstable,
      nixos-hardware,
      nixpkgs-master,
      nur,
      sops-nix,
      home-manager,
      chiri,
      antec-flux-pro-display,
      ...
    }@inputs:
    let
      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      nixosConfigurations = {
        # Laptop
        finka = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            disko.nixosModules.disko
            nur.modules.nixos.default
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops

            ./base.nix
            ./hosts/finka
          ];

          specialArgs = {
            inherit inputs nixos-hardware;
            nixos-unstable = inputs.nixos-unstable.legacyPackages.x86_64-linux;
            nixpkgs-master = inputs.nixpkgs-master.legacyPackages.x86_64-linux;
          };
        };

        # Workstation
        reaper = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            disko.nixosModules.disko
            nur.modules.nixos.default
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

        # Laptop
        moira = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            disko.nixosModules.disko
            nur.modules.nixos.default
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

        # Desktop
        ana = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            disko.nixosModules.disko
            nur.modules.nixos.default
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
