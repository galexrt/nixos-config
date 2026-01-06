{ config, lib, pkgs, nixos-hardware, ... }:

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

  services.greetd.settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --cmd '${pkgs.sway}/bin/sway --unsupported-gpu'";

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
      version = "590.44.01";
      sha256_64bit = "sha256-VbkVaKwElaazojfxkHnz/nN/5olk13ezkw/EQjhKPms=";
      sha256_aarch64 = "sha256-gpqz07aFx+lBBOGPMCkbl5X8KBMPwDqsS+knPHpL/5g=";
      openSha256 = "sha256-ft8FEnBotC9Bl+o4vQA1rWFuRe7gviD/j1B8t0MRL/o=";
      settingsSha256 = "sha256-wVf1hku1l5OACiBeIePUMeZTWDQ4ueNvIk6BsW/RmF4=";
      persistencedSha256 = "sha256-nHzD32EN77PG75hH9W8ArjKNY/7KY6kPKSAhxAWcuS4=";
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
