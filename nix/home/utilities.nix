{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    bat
    direnv
    htop
    unzip
  ];

  programs.fzf.enable = true;
  programs.lsd.enable = true;
}
