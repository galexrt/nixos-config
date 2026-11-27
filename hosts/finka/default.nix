{
  config,
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
  myConfig.virtualisation.enable = true;
  myConfig.binfmt.enable = true;
  myConfig.vpnTools.enable = true;
  myConfig.desktop.sway.enable = true;
  myConfig.gaming.enable = true;
  myConfig.bluetooth.enable = true;
  myConfig.printing.enable = true;
  myConfig.windowsApps.enable = true;

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

  home-manager.users.atrost.wayland.windowManager.sway.config = {
    output = {
      eDP-1 = {
        scale = "1";
        adaptive_sync = "on";
        hdr = "on";
        render_bit_depth = "10";
        allow_tearing = "yes";
        max_render_time = "off";
      };
    };
    workspaceOutputAssign = [
      {
        workspace = "1";
        output = "eDP-1";
      }
    ];
  };

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

    # Pin specific driver version - <https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix#L73>
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "615.71.09";
      sha256_64bit = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
      sha256_aarch64 = "sha256-IbekQhE7cFfmnPZaLY9NDYcF7CoNZ+2Qb7sRd4EOgWM=";
      openSha256 = "sha256-3gByMYIwFzRaLdDG+roCEOuKRRJDrljG9AlLnRZTirM=";
      settingsSha256 = "sha256-LK1LU8mDkM/XVRKPBtuOZh9nIP/lGFLAJnmasEX8jhg=";
      persistencedSha256 = "sha256-qPRb+3d88+2RcpUkoBTbjIaImnQ+jX+/6p1vXcJ5geE=";
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
