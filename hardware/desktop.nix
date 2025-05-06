
{ config, pkgs, ... }:

{
  imports = [ ];

  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
}
