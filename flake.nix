{
  inputs = {
    # Nixpkgs
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };
    nixos-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-master = {
      url = "github:NixOS/nixpkgs/master";
    };

    # NUR
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lanzaboote
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Treefmt
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Hardware
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # SOPS
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixcord
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia Shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chiri
    chiri = {
      url = "github:chiriapp/chiri";
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
      nixpkgs,
      nixos-unstable,
      nixos-hardware,
      nixpkgs-master,
      nur,
      disko,
      lanzaboote,
      treefmt-nix,
      sops-nix,
      home-manager,
      nixcord,
      noctalia,
      chiri,
      antec-flux-pro-display,
      ...
    }@inputs:
    let
      supportedSystems = [ "x86_64-linux" ];
      # Small tool to iterate over each supported system
      eachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});
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
            lanzaboote.nixosModules.lanzaboote
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
            lanzaboote.nixosModules.lanzaboote
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
            lanzaboote.nixosModules.lanzaboote
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
