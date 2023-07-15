{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
  ];

  networking.hostName = "";

  system.stateVersion = "22.11";
}
