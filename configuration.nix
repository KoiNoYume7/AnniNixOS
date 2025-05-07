### NixOS Config for Akira (Laptop + Desktop Hybrid Setup)
# Base directory: /etc/nixos/
# Username: akira

{ config, pkgs, ... }:
{
  imports = [
    ./hardware/laptop.nix
    # Uncomment the next line for desktop setup
    # ./hardware/desktop.nix
  ];

  fileSystems."/" = {
    device = "/dev/nvme0n1p5";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  ### Boot Options
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "loglevel=7" ];
  boot.consoleLogLevel = 7;
  boot.plymouth.enable = false;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true; # Handles WLAN + LAN

  ### Localization
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  ### Users
  users.users.akira = {
    isNormalUser = true;
    description = "Akira";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  ### Hyprland & Environment
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # nvidiaPatches = true; # only if using NVIDIA
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    hyprland waybar wofi kitty swww neovim git curl wget
    firefox steam discord spotify
    opera
    bluez pulseaudio pavucontrol
    networkmanagerapplet

    # Wine & helpers
    wineWowPackages.stable
    winetricks
    bottles
    lutris
    mangohud
    gamescope
    vulkan-tools

    # Fun / testing stuff
    lolcat cowsay htop
  ];

  ### Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  ### Sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;
  hardware.pulseaudio.support32Bit = true;
  security.rtkit.enable = true;

  ### OpenGL + Vulkan support
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  ### NVIDIA-specific (optional, uncomment if needed)
  # hardware.nvidia.modesetting.enable = true;

  ### Allow Unfree Packages (Steam, Discord, etc.)
  nixpkgs.config.allowUnfree = true;

  ### Flatpak Support
  services.flatpak.enable = true;

  ### Systemd Service: Fancy Boot Logs
  systemd.services.yume-bootlog = {
    description = "Yume Protocol Bootlog";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo \"[✓] Yume Protocol Activated\"'";
      Type = "oneshot";
    };
  };

  system.stateVersion = "23.11";
}
