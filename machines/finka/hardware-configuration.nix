# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4dc3873b-640d-4e62-9814-c30fb92b1947";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  boot.initrd.luks = {
    devices = {
      "encd1" = {
        device = "/dev/disk/by-uuid/49e30aa3-93ac-490a-b524-db5b9598990b";
        allowDiscards = true;
      };
      "encs1" = {
        device = "/dev/disk/by-uuid/deca0040-6665-4573-b74f-c9bf6dc253c6";
        allowDiscards = true;
      };
      "encd2" = {
        device = "/dev/disk/by-uuid/1a4be654-d34a-4873-821c-b35f137cc27a";
        allowDiscards = true;
      };
      "encs2" = {
        device = "/dev/disk/by-uuid/ec74f554-532b-4435-9658-7cb3f2bf7e16";
        allowDiscards = true;
      };
    };
    reusePassphrases = true;
  };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/4dc3873b-640d-4e62-9814-c30fb92b1947";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/4dc3873b-640d-4e62-9814-c30fb92b1947";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/4dc3873b-640d-4e62-9814-c30fb92b1947";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
    };

  fileSystems."/var/lib" =
    { device = "/dev/disk/by-uuid/4dc3873b-640d-4e62-9814-c30fb92b1947";
      fsType = "btrfs";
      options = [ "subvol=var-lib" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/4dc3873b-640d-4e62-9814-c30fb92b1947";
      fsType = "btrfs";
      options = [ "subvol=var-log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D891-634B";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/0fa2aaad-1704-4c3a-8fc6-bac3eeddf913"; }
      { device = "/dev/disk/by-uuid/676d72c4-a361-4966-b7d1-38ec4e8c02cf"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}