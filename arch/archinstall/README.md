# Archinstall — God-King / niri

Uses official [archinstall](https://github.com/archlinux/archinstall) **Desktop → niri** (LightDM + seatd), then `arch/setup.sh` via `custom_commands`.

Disk layout:

```
/boot  FAT32 ESP (1 GiB, unencrypted)
nvme0n1p2  LUKS → LVM (arch) → btrfs
  @      /
  @home  /home
  @log   /var/log
  @pkg   /var/cache/pacman/pkg
```

Encryption: **`lvm_on_luks`**.

## Before you install

1. Confirm `disk_config` device (`/dev/nvme0n1`) — **`wipe: true`**.
2. On another disk size, re-save a layout from archinstall or adjust PV/LV sizes.
3. Credentials:

```bash
cp user_credentials.json.example user_credentials.json
# encryption_password = LUKS passphrase (plaintext)
# enc_password fields = openssl passwd -6
```

## Install (Arch ISO)

```bash
pacman -Sy --noconfirm git archinstall
cd /path/to/dotfiles/arch/archinstall
archinstall --config user_configuration.json --creds user_credentials.json
```

Reboot → unlock LUKS → LightDM → **Niri**.

## Graphics

Default: `Nvidia (open kernel module for newer GPUs, Turing+)`.  
Change `profile_config.gfx_driver` for AMD/Intel (e.g. `"All open-source"`).
