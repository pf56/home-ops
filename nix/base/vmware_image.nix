{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ../roles/vmwareguest
  ];

  networking.hostName = "";

  system.stateVersion = "22.11";
}
