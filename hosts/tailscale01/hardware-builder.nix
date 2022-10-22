{ config, pkgs, ... }:

{
  # enable vmware tools
  virtualisation.vmware.guest.enable = true;
}