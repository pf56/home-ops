{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ../../roles/vmware_guest.nix
  ];

  networking.hostName = "";

  system.stateVersion = "22.11";
}
