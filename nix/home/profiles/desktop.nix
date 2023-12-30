{ config, lib, ... }:
{
  imports = [
    ../gtk.nix
    ../sway.nix
    ../utilities-desktop.nix
  ];

  modules = {
    hyprland.enable = true;
    eww.enable = true;
    mako.enable = true;
  };
}
