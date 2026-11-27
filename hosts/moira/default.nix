{
  nixos-hardware,
  ...
}:

{
  imports = [
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../users/atrost.nix
  ];

  networking.hostName = "moira";

  myConfig.virtualisation.enable = true;
  myConfig.binfmt.enable = true;
  myConfig.vpnTools.enable = true;
  myConfig.desktop.sway.enable = true;
  myConfig.gaming.enable = true;
  myConfig.bluetooth.enable = true;
  myConfig.printing.enable = true;
  myConfig.windowsApps.enable = true;

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
}
