{ lib, ... }:
{
  den.aspects.librewolf = {
    homeManager =
      { pkgs, ... }:
      {
        programs.librewolf = {
          enable = true;
          settings = {
            "identity.fxaccounts.enabled" = true;
            "privacy.clearOnShutdown.history" = false;
            "middlemouse.paste" = false;
          };
        };

        xdg.desktopEntries = {
          librewolf = {
            name = "LibreWolf";
            exec = "${pkgs.librewolf}/bin/librewolf --name librewolf %U";
            genericName = "Web Browser";
            icon = "librewolf";
            type = "Application";
            startupNotify = true;
            terminal = false;

            categories = [
              "Network"
              "WebBrowser"
            ];

            mimeType = [
              "text/html"
              "text/xml"
              "application/xhtml+xml"
              "application/vnd.mozilla.xul+xml"
              "x-scheme-handler/http"
              "x-scheme-handler/https"
            ];

            actions = {
              "new-private-window" = {
                name = "New Private Window";
                exec = "${pkgs.librewolf}/bin/librewolf --private-window %U";
              };

              "new-window" = {
                name = "New Window";
                exec = "${pkgs.librewolf}/bin/librewolf --new-window %U";
              };

              "profile-manager-window" = {
                name = "Profile Manager";
                exec = "${pkgs.librewolf}/bin/librewolf --ProfileManager";
              };
            };
          };
        };
      };
  };
}
