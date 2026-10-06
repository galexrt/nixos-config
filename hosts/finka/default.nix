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

  services.displayManager.noctalia-greeter.settings.session.default = "Sway (NVIDIA)";

  services.displayManager.sessionPackages = [
    ((pkgs.writeTextDir "share/wayland-sessions/sway-nvidia.desktop" ''
        [Desktop Entry]
        Name=Sway (NVIDIA)
        Comment=Sway session using the Vulkan renderer
        Exec=/home/atrost/.local/bin/sway-session.sh true
        Type=Application
        DesktopNames=sway
      '').overrideAttrs (_: { passthru.providedSessions = [ "sway-nvidia" ]; }))
  ];

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
      version = "610.57.04";
      sha256_64bit = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
      sha256_aarch64 = "sha256-QCefrMBCmpOwuOyXv1k5Gj0iB2CYlPgnG3JToUw/j54=";
      openSha256 = "sha256-rQHOOOY4KL92Ww3KDwh+j4eGU7oNAH8LutZC5wmFnPo=";
      settingsSha256 = "sha256-ZEMo8I8Zc2Tq6RVDNYpAH+f094dUaZiBqO+5f6lIjRI=";
      persistencedSha256 = "sha256-aXmD2VY1RLlgAnlHhOUMWzvMyhI6JTClcFLm4imF/mA=";
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

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
      };
    };
  };
}
