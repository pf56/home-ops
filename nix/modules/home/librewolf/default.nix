{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.librewolf;
in
{
  options.modules.librewolf = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
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
}
