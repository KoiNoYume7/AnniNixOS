
{ config, pkgs, ... }:

{
  imports = [ ];

  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = [ "intel" ];
}
