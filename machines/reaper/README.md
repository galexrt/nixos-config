# reaper

```bash
mount -o subvol=root,noatime /dev/mapper/encs1 /mnt

mkdir -p /mnt/home
mount -o subvol=home,noatime /dev/mapper/encs1 /mnt/home

mkdir -p /mnt/nix
mount -o subvol=nix,noatime /dev/mapper/encs1 /mnt/nix

mkdir -p /mnt/persist
mount -o subvol=persist,noatime /dev/mapper/encs1 /mnt/persist

mkdir -p /mnt/var/lib
mount -o subvol=var-lib,noatime /dev/mapper/encs1 /mnt/var/lib

mkdir -p /mnt/var/log
mount -o subvol=var-log,compress=zstd,noatime /dev/mapper/encs1 /mnt/var/log
```
