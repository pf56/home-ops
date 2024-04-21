{ pkgs, config, lib, inputs, ... }:

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
    gtk.enable = true;
    hyprland.enable = true;
    wpaperd.enable = true;
    eww.enable = true;
    mako.enable = true;
  };

  home.packages = with pkgs; [
    xfce.thunar
    xfce.thunar-archive-plugin
  ];

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = [ "thunar.desktop" "nnn.desktop" ];
  };
}
