{ config, pkgs, nixos-hardware, nixpkgs-master, ... }:

{
  imports = [
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-ssd

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../users/atrost.nix
  ];

  networking.hostName = "finka";

  services.xserver.videoDrivers = [ "nvidia" ];

  services.greetd.settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --cmd '${nixpkgs-master}/bin/sway --unsupported-gpu'";

  hardware.nvidia = {
    modesetting.enable = true;

    prime = {
      /*
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      */
      sync.enable = true;

      amdgpuBusId = "PCI:07:00:0";
      nvidiaBusId = "PCI:01:00:0";
    };

    powerManagement = {
      enable = false;
      finegrained = false;
    };

    open = false;

    nvidiaSettings = true;

    # Pin specific driver version
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.71.05";
      sha256_64bit = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
      sha256_aarch64 = "sha256-XzKloS00dFKTd4ATWkTIhm9eG/OzR/Sim6MboNZWPu8=";
      openSha256 = "sha256-Lfz71QWKM6x/jD2B22SWpUi7/og30HRlXg1kL3EWzEw=";
      settingsSha256 = "sha256-mXnf3jyvznfB3OfKd657rxv0rYHQb/dX/Riw/+N9EKU=";
      persistencedSha256 = "sha256-Z/6IvEEa/XfZ5F5qoSIPvXJLGtscYVqjFxHZaN/M2Ts=";
    };
  };

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  home-manager.users.atrost = {
    home.packages = with pkgs; [
      openrgb-with-all-plugins
    ];
  };
}
