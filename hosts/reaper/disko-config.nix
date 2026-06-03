{
  disko.devices = {
    disk = {
      disk0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4EWNX0W492206M_1";
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
                  "fmask=0077"
                  "umask=0077"
                ];
              };
            };

            crypt = {
              size = "100%";
              content = {
                type = "luks";
                name = "encs0";
                settings = {
                  allowDiscards = true;
                };
              };
            };
          };
        };
      };

      disk1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S6P7NF0W310994N_1";
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
                  "fmask=0077"
                  "umask=0077"
                ];
              };
            };

            crypt = {
              size = "100%";
              content = {
                type = "luks";
                name = "encs1";
                settings = {
                  allowDiscards = true;
                };
              };
            };
          };
        };
      };

      disk2 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S6P7NF0W311589E_1";
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
                  "fmask=0077"
                  "umask=0077"
                ];
              };
            };

            crypt = {
              size = "100%";
              content = {
                type = "luks";
                name = "encs2";
                settings = {
                  allowDiscards = true;
                };
              };
            };
          };
        };
      };

      disk3 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S6P7NF0W310989A_1";
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
                  "fmask=0077"
                  "umask=0077"
                ];
              };
            };

            crypt = {
              size = "100%";
              content = {
                type = "luks";
                name = "encs3";
                settings = {
                  allowDiscards = true;
                };
                # Create the Btrfs RAID10 filesystem here after the first three
                # encrypted devices have been opened.
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-d"
                    "raid10"
                    "-m"
                    "raid10"
                    "/dev/mapper/encs0"
                    "/dev/mapper/encs1"
                    "/dev/mapper/encs2"
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
          };
        };
      };
    };
  };
}
