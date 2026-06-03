{ pkgs, nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd

    ./disko-config.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../users/atrost.nix
  ];

  networking.hostName = "reaper";

  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = {
      # this path because we don't use pkgs.lact
      ExecStart = "/run/current-system/sw/bin/lact daemon";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Papers Please!
  services.paperless = {
    enable = true;
    consumptionDirIsPublic = true;
    address = "0.0.0.0";

    settings = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_CONSUMER_RECURSIVE = true;
      PAPERLESS_TASK_WORKERS = 4;
      PAPERLESS_THREADS_PER_WORKER = 2;
      PAPERLESS_WEBSERVER_WORKERS = 2;
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "paperless" ];
    ensureUsers = [
      {
        name = "paperless";
        ensureDBOwnership = true;
      }
    ];
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
