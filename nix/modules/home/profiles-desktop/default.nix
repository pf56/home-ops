{
  pkgs,
  config,
  nixosConfig,
  lib,
  inputs,
  flake,
  ...
}:

let
  nix-colors = inputs.nix-colors;
in
{
  imports = [
    nix-colors.homeManagerModules.default

    flake.homeModules.utilities-desktop
    flake.homeModules.gtk
    flake.homeModules.wpaperd
    flake.homeModules.mako
    flake.homeModules.river
    flake.homeModules.kanshi
    flake.homeModules.waybar
    flake.homeModules.gaming
    flake.homeModules.vfio
    flake.homeModules.bongocat
  ];

  config = lib.mkMerge [
    ({

      colorScheme = nix-colors.colorSchemes.nord;

      modules = {
        gtk.enable = true;
        wpaperd.enable = true;
        mako.enable = true;
        river.enable = true;
        kanshi.enable = true;
        waybar.enable = true;
        gaming.enable = true;
        bongocat.enable = true;
      };

      home.packages = with pkgs; [
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

      xdg =
        let
          browser = [
            "librewolf.desktop"
          ];

          associations = {
            "inode/directory" = [
              "thunar.desktop"
              "nnn.desktop"
            ];

            "text/html" = browser;
            "x-scheme-handler/http" = browser;
            "x-scheme-handler/https" = browser;
            "x-scheme-handler/about" = browser;
            "x-scheme-handler/unknown" = browser;
            "application/x-extension-htm" = browser;
            "application/x-extension-html" = browser;
            "application/x-extension-shtml" = browser;
            "application/xhtml+xml" = browser;
            "application/x-extension-xhtml" = browser;
            "application/x-extension-xht" = browser;
          };
        in
        {
          portal = {
            enable = true;
            xdgOpenUsePortal = true;

            config = {
              river = {
                default = [ "gtk" ];
                "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
                "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
              };
            };

            extraPortals = with pkgs; [
              xdg-desktop-portal-gtk
              xdg-desktop-portal-wlr
            ];
          };

          mimeApps = {
            enable = true;
            associations.added = associations;
            defaultApplications = associations;
          };
        };
    })

    (lib.mkIf (builtins.elem "vfio" nixosConfig.system.nixos.tags) {
      modules.vfio.enable = true;
    })
  ];
}
