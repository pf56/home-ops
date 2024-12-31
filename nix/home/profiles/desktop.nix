{ pkgs, config, lib, inputs, ... }:

let
  ghostty = inputs.ghostty;
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
    river.enable = true;
    kanshi.enable = true;
    waybar.enable = true;
  };

  home.packages = with pkgs; [
    ghostty.packages.${stdenv.hostPlatform.system}.default
    wlr-randr
    xfce.thunar
    xfce.thunar-archive-plugin
  ];

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = [ "thunar.desktop" "nnn.desktop" ];
  };
}
