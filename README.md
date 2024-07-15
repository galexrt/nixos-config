# nixos-config

The NixOS config of a NixOS newbie ;-)

The config here can probably be improved a lot by someone that knows more about NixOS, though as it stands the config works fine for me and helps me reduce time spent on configs/OS issues.

## Hosts

### moira - Laptops

Instructions are based on <https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html> post.

```bash
DISK=/dev/nvme0n1

# Created using `sfdisk -d "$DISK"
cat <<'EOF' | sfdisk "$DISK"
label: gpt
label-id: 64BDF7C8-B86F-4082-B943-2312025292A8
device: /dev/nvme0n1
unit: sectors
first-lba: 2048
last-lba: 2000409230
sector-size: 512

/dev/nvme0n1p1 : start=        4096, size=     1048576, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, uuid=46A59B92-0161-4400-8484-6C167093055B
/dev/nvme0n1p2 : start=     1052672, size=  1999356559, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=52D13C9F-4DF1-4BBB-8B31-8CD4CE3C0503, name="root"

EOF
sgdisk -G "$DISK"

cryptsetup --verify-passphrase -v luksFormat "$DISK"p2
cryptsetup open "$DISK"p2 encd

mkfs.vfat -n boot "$DISK"p1
mkfs.btrfs /dev/mapper/encd

mount -t btrfs /dev/mapper/encd /mnt

btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/var-lib
btrfs subvolume create /mnt/var-log

btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

sync

mount -o subvol=root,noatime /dev/mapper/encd /mnt

mkdir -p /mnt/home
mount -o subvol=home,noatime /dev/mapper/encd /mnt/home

mkdir -p /mnt/nix
mount -o subvol=nix,noatime /dev/mapper/encd /mnt/nix

mkdir -p /mnt/persist
mount -o subvol=persist,noatime /dev/mapper/encd /mnt/persist

mkdir -p /mnt/var/lib
mount -o subvol=var-lib,noatime /dev/mapper/encd /mnt/var/lib

mkdir -p /mnt/var/log
mount -o subvol=var-log,compress=zstd,noatime /dev/mapper/encd /mnt/var/log

mkdir /mnt/boot
mount "$DISK"p1 /mnt/boot

# Upload /mnt/etc/nixos/configuration.nix file to machine

nixos-install
sync

reboot
```

### reaper - Workstation

TODO
