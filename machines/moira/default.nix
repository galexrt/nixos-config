{ lib, ... }:

{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/laptop"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/ssd"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/p14s/amd/gen2"
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
