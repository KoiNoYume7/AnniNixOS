
{ config, pkgs, ... }:

{
  imports = [
    ./hardware/laptop.nix
    # ./hardware/desktop.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "loglevel=7" ];
  boot.consoleLogLevel = 7;
  boot.plymouth.enable = false;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de_CH";

  users.users.akira = {
    isNormalUser = true;
    description = "Akira";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.windowManager.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprland waybar wofi kitty swww neovim git curl wget
    firefox steam discord spotify
    bluez bluez-utils pulseaudio pavucontrol
    networkmanagerapplet
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;

  hardware.opengl.enable = true;

  nixpkgs.config.allowUnfree = true;

  systemd.services.yume-bootlog = {
    description = "Yume Protocol Bootlog";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo "[✓] Yume Protocol Activated"'";
      Type = "oneshot";
    };
  };

  system.stateVersion = "23.11";
}
