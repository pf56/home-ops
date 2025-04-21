{ pkgs, config, lib, inputs, ... }:

let
  ghostty = inputs.ghostty;
  nix-colors = inputs.nix-colors;
in
{
  imports = [
    nix-colors.homeManagerModules.default
    ../utilities-desktop.nix
  ];

  colorScheme = nix-colors.colorSchemes.nord;

  modules = {
    gtk.enable = true;
    wpaperd.enable = true;
    mako.enable = true;
    river.enable = true;
    kanshi.enable = true;
    waybar.enable = true;
    gaming.enable = true;
    vfio.enable = true;
  };

  home.packages = with pkgs; [
    ghostty.packages.${stdenv.hostPlatform.system}.default
    wlr-randr
    xfce.thunar
    xfce.thunar-archive-plugin
  ];

  programs.librewolf = {
    enable = true;
    settings = {
      "identity.fxaccounts.enabled" = true;
      "privacy.clearOnShutdown.history" = false;
      "middlemouse.paste" = false;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" "nnn.desktop" ];

      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };
}
