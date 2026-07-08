{
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-ssd

    ./disko-config.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../users/atrost.nix
    ../../options/lanzaboote.nix
  ];

  networking.hostName = "finka";

  myConfig.lanzaboote.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  services.greetd.settings.default_session.command =
    "${pkgs.tuigreet}/bin/tuigreet --cmd '/home/atrost/.local/bin/sway-session.sh true'";

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
      version = "595.84";
      sha256_64bit = "sha256-mcQE5SExvye8ptoCaNzOPr7cenOrF0BxqZXPGmxeugY=";
      sha256_aarch64 = "sha256-GloNdDFfmXFVu4FAlNNk2qzqLOuw2N5CKatKkcSrQxk=";
      openSha256 = "sha256-pEmA2tUcOKwUPKy6N0QvS49Pdut4/7Phs/JhjdyBcNY=";
      settingsSha256 = "sha256-QrnBM+sdWO4GanO62rxpHmRrjYkYpl5RD6fIiHq4C4A=";
      persistencedSha256 = "sha256-50xYdgx7EEThbaMp4QS8GADbxj0mhBXh8QQN0tWMwRg=";
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
