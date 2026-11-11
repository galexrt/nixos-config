{
  lib,
  pkgs,
  nixos-hardware,
  ...
}:

{
  imports = [
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd

    ./disko-config.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../users/atrost.nix
    ../../options/lanzaboote.nix
  ];

  networking.hostName = "reaper";

  myConfig.lanzaboote.enable = true;

  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = {
      # this path because we don't use pkgs.lact
      ExecStart = "/run/current-system/sw/bin/lact daemon";
    };
    wantedBy = [ "multi-user.target" ];
  };

  services.ollama = {
    package = pkgs.ollama-rocm;
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100";
    };
    rocmOverrideGfx = "11.0.0";
  };

  services.antec-flux-pro-display = {
    enable = true;
    settings = {
      cpu_device = "coretemp";
      cpu_temp_type = "Package id 0";
      gpu_device = "amdgpu";
      gpu_temp_type = "edge";
      update_interval = 1000;
    };
  };

}
