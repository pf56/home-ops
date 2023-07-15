{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    bat
    evince
    htop
    unzip
  ];

  programs.fzf.enable = true;
  programs.lsd.enable = true;
}
