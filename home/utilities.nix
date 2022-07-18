{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    bat
    evince
    htop
    unzip
  ];

  programs.lsd.enable = true;
}
