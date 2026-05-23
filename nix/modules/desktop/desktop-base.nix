{ lib, ... }:
{
  den.aspects.desktop-base = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          flatpak
          nautilus
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
                preferred = {
                  default = [ "gtk" ];
                  "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
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
      };
  };
}
