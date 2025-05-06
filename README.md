
# AnniNixOS

Akira's NixOS config for laptop + desktop with Hyprland.

## Install Steps (Laptop)

1. Boot into NixOS USB
2. Format target partition (e.g., `/dev/sda5`) with ext4
3. Mount root: `mount /dev/sda5 /mnt`
4. Mount EFI: `mount /dev/sda1 /mnt/boot`
5. Generate base config: `nixos-generate-config --root /mnt`
6. Clone this repo into `/mnt/etc/nixos`
7. Run `nixos-install`

Make sure `imports = [ ./hardware/laptop.nix ];` is set in `configuration.nix`.

Dual boot safe — systemd-boot will auto-detect Windows.
