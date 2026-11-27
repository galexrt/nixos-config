{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.virtualisation;
in
{
  options.myConfig.virtualisation = {
    enable = lib.mkEnableOption "virtualisation support";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;

      docker = {
        enable = true;
        liveRestore = true;
        storageDriver = "overlay2";
      };

      podman = {
        enable = true;
        dockerCompat = false;
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };

      virtualbox.host.enable = false;

      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          vhostUserPackages = with pkgs; [ virtiofsd ];
        };
      };

      spiceUSBRedirection.enable = true;
    };

    programs.virt-manager.enable = true;

    home-manager.users.atrost.home.file."libvirt-qemu-conf" = {
      text = ''
        # Adapted from /var/lib/libvirt/qemu.conf
        # Note that AAVMF and OVMF are for Aarch64 and x86 respectively
        nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
      '';
      target = ".config/libvirt/qemu.conf";
    };

    environment.systemPackages = with pkgs; [
      bridge-utils
      qemu
      freerdp
    ];
  };
}
