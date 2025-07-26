{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  imports = [
    flake.homeModules.git
    flake.homeModules.gpg
    flake.homeModules.ssh
    flake.homeModules.utilities
    flake.homeModules.zsh
  ];

  home.packages = with pkgs; [
    nnn
  ];

  programs.home-manager.enable = true;
}
