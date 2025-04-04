{ config, lib, pkgs, ... }:

{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/laptop"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/laptop/ssd"
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "finka";

  services.xserver.videoDrivers = [ "nvidia" ];

  services.greetd.settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd '${pkgs.sway}/bin/sway --unsupported-gpu'";

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

    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  home-manager.users.atrost = {
    home.packages = with pkgs; [
      openrgb-with-all-plugins
    ];

    programs.waybar = {
      settings = {
        default = {
          "temperature" = {
            hwmon-path = "/sys/class/hwmon/hwmon5/temp1_input";
          };
        };
      };
    };
  };
}
