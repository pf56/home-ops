{ config, lib, inputs, ... }:

let
  nix-colors = inputs.nix-colors;
in
{
  imports = [
    nix-colors.homeManagerModules.default
    ../gtk.nix
    ../sway.nix
    ../utilities-desktop.nix
  ];

  colorScheme = nix-colors.colorSchemes.nord;

  modules = {
    hyprland.enable = true;
    eww.enable = true;
    mako.enable = true;
  };
}
