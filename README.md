# nixos-config

The NixOS config of a NixOS newbie ;-)

The config here can probably be improved a lot by someone that knows more about NixOS, though as it stands the config works fine for me and helps me reduce time spent on configs/OS issues.

## Hosts

### finka - Laptop

```bash
sudo -i
DISK1=/dev/nvme0n1
DISK2=/dev/nvme1n1

# Disk 1 ===
# Created using `sfdisk -d "$DISK1"`
cat <<'EOF' | sfdisk "$DISK1"
label: gpt
label-id: ABD779CE-688D-444B-A20A-EB0BF679ABFB
device: /dev/nvme0n1
unit: sectors
first-lba: 34
last-lba: 1953525134
sector-size: 512

/dev/nvme0n1p1 : start=        2048, size=     1046529, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, uuid=5E5253F9-808F-4F2E-B066-1640F3227F26, name="EFI system partition"
/dev/nvme0n1p2 : start=     1050624, size=  1677598720, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=7DEAD2F8-C298-41A4-87E1-AACB43D5D7E4, name="root"
/dev/nvme0n1p3 : start=  1678649344, size=   274874368, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=1F922D39-9E1F-4D7D-9D3A-1DBBB76A1E64, name="swap"

EOF

cryptsetup --verify-passphrase -v luksFormat "$DISK1"p2
cryptsetup open "$DISK1"p2 encd1
cryptsetup --verify-passphrase -v luksFormat "$DISK1"p3
cryptsetup open "$DISK1"p3 encs1

mkfs.vfat -n boot "$DISK1"p1

# Disk 2 ===
# Created using `sfdisk -d "$DISK2"`
cat <<'EOF' | sfdisk "$DISK2"
label: gpt
label-id: 1DFE61B4-92D0-4B71-B190-1B7336C15B28
device: /dev/nvme1n1
unit: sectors
first-lba: 34
last-lba: 1953525134
sector-size: 512

/dev/nvme1n1p1 : start=        2048, size=     1046529, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, uuid=E24216F8-173C-445C-BC94-546E5869CE4F, name="EFI system partition"
/dev/nvme1n1p2 : start=     1050624, size=  1677598720, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=8F60FFAF-0042-469B-81D0-75AE9638A79B, name="root"
/dev/nvme1n1p3 : start=  1678649344, size=   274874368, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, uuid=C2DBA47B-7735-4E25-A7E9-B82916130CF0, name="swap"

EOF
#sgdisk -G "$DISK2"

cryptsetup --verify-passphrase -v luksFormat "$DISK2"p2
cryptsetup open "$DISK2"p2 encd2
cryptsetup --verify-passphrase -v luksFormat "$DISK2"p3
cryptsetup open "$DISK2"p3 encs2

mkfs.vfat -n boot "$DISK2"p2

mkfs.btrfs /dev/mapper/encd1
mkfs.btrfs /dev/mapper/encd2

mkswap /dev/mapper/encs1
mkswap /dev/mapper/encs2

mount -t btrfs /dev/mapper/encd1 /mnt

btrfs device add /dev/mapper/encd2 /mnt -f
btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt

btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/var-lib
btrfs subvolume create /mnt/var-log

btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt

sync

mount -o subvol=root,noatime /dev/mapper/encd1 /mnt

mkdir -p /mnt/home
mount -o subvol=home,noatime /dev/mapper/encd1 /mnt/home

mkdir -p /mnt/nix
mount -o subvol=nix,noatime /dev/mapper/encd1 /mnt/nix

mkdir -p /mnt/persist
mount -o subvol=persist,noatime /dev/mapper/encd1 /mnt/persist

mkdir -p /mnt/var/lib
mount -o subvol=var-lib,noatime /dev/mapper/encd1 /mnt/var/lib

mkdir -p /mnt/var/log
mount -o subvol=var-log,compress=zstd,noatime /dev/mapper/encd1 /mnt/var/log

mkdir /mnt/boot
mount "$DISK1"p1 /mnt/boot

# Upload /mnt/etc/nixos/configuration.nix file to machine

nixos-install
sync

reboot
```

### moira - Laptops

Instructions are based on <https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html> post.

```bash
sudo -i
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
