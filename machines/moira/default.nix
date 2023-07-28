{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/p14s/amd/gen2"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/ssd"
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  #config.wayland.windowManager.sway.scale = "1.25";
}
