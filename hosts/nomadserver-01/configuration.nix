{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
    ../../roles/vmware_guest.nix
    ../../roles/nomad_server.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nomadserver-01";

  system.stateVersion = "22.11";
}