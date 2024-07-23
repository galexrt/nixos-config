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

  services.greetd.settings.default_session.command = lib.mkForce "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd ${pkgs.sway}/bin/sway --unsupported-gpu --my-next-gpu-wont-be-nvidia";

  hardware.nvidia = {
    modesetting.enable = true;

    prime = {
      offload.enable = true;

      amdgpuBusId = "PCI:07:00:0";
      nvidiaBusId = "PCI:01:00:0";
    };

    powerManagement.enable = true;

    powerManagement.finegrained = true;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
