{
  pkgs,
  config,
  nixosConfig,
  lib,
  inputs,
  flake,
  ...
}:

{
  imports = [
    flake.homeModules.bongocat
    flake.homeModules.gaming
    flake.homeModules.gtk
    flake.homeModules.kanshi
    flake.homeModules.librewolf
    flake.homeModules.mako
    flake.homeModules.niri
    flake.homeModules.qt
    flake.homeModules.river
    flake.homeModules.thunar
    flake.homeModules.utilities-desktop
    flake.homeModules.vfio
    flake.homeModules.waybar
    flake.homeModules.wpaperd
  ];

  config = lib.mkMerge [
    ({

      stylix = {
        enable = true;
        base16Scheme = nixosConfig.stylix.base16Scheme;
        image = ./wallpapers/wild.png;

        cursor = {
          name = "Nordic-cursors";
          package = pkgs.nordic;
          size = 24;
        };

        fonts = {
          serif = {
            package = pkgs.noto-fonts;
            name = "Noto Serif";
          };

          sansSerif = {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
          };

          monospace = {
            package = pkgs.jetbrains-mono;
            name = "JetBrainsMono";
          };

          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };

        icons = {
          enable = true;
          dark = "Nordzy";
          package = pkgs.nordzy-icon-theme;
        };

        targets.mangohud.enable = false;
        targets.librewolf.enable = false;
      };

      modules = {
        bongocat.enable = true;
        gaming.enable = true;
        librewolf.enable = true;
        mako.enable = true;
        niri.enable = true;
        #river.enable = true;
        thunar.enable = true;
        waybar.enable = true;
        wpaperd.enable = true;
      };

      home.packages = with pkgs; [
        flatpak
        swaylock
        wlr-randr
      ];

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
              xdg-desktop-portal-gnome
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
