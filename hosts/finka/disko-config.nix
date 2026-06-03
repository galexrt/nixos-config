{
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S6Z1NU0X234940X_1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountOptions = [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };

            root = {
              end = "-132G";
              content = {
                type = "luks";
                name = "encd1";
                settings = {
                  allowDiscards = true;
                };
              };
            };

            swap = {
              size = "132G";
              content = {
                type = "luks";
                name = "encs1";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "swap";
                };
              };
            };
          };
        };
      };

      nvme1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S6Z1NU0X234937F_1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };

            root = {
              end = "-132G";
              content = {
                type = "luks";
                name = "encd2";
                settings = {
                  allowDiscards = true;
                };
                # Create the mirrored Btrfs filesystem here after the first
                # encrypted root device has been opened.
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-d"
                    "raid1"
                    "-m"
                    "raid1"
                    "/dev/mapper/encd1"
                  ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "noatime" ];
                    };

                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/var-lib" = {
                      mountpoint = "/var/lib";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/var-log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };

            swap = {
              size = "132G";
              content = {
                type = "luks";
                name = "encs2";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "swap";
                };
              };
            };
          };
        };
      };
    };
  };
}
