{ pkgs, home-manager, ... }:

{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc"
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/common/pc/ssd"
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "reaper";

  services.nfs.server = {
    enable = true;
    exports = ''
      /data/DATA/topsecret/Music 172.16.1.101(rw,fsid=0,no_subtree_check)
      /data/DATA/topsecret/Music 172.16.1.222(rw,fsid=0,no_subtree_check)
    '';
  };

  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;
    serviceConfig = {
      # this path because we don't use pkgs.lact
      ExecStart = "/run/current-system/sw/bin/lact daemon";
    };
    wantedBy = [ "multi-user.target" ];
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
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

}
