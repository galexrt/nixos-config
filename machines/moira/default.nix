{ lib, home-manager, nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../users/atrost.nix
  ];

  networking.hostName = "moira";

  home-manager.users.atrost = {
    programs.waybar = {
      settings = {
        default = {
          "temperature" = {
            hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
          };
        };
      };
    };
  };
}
