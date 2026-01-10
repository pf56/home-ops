{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.thunar;
in
{
  options.modules.thunar = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      thunar
      thunar-archive-plugin
    ];

    xdg.desktopEntries = {
      thunar = {
        name = "Thunar File Manager";
        exec = "${pkgs.thunar}/bin/thunar %U";
        genericName = "File Manager";
        icon = "org.xfce.thunar";
        type = "Application";
        startupNotify = true;
        terminal = false;
        categories = [ "System" ];
        mimeType = [ "inode/directory" ];

        actions = {
          "open-home" = {
            name = "Home";
            exec = "${pkgs.thunar}/bin/thunar %U";
          };

          "open-computer" = {
            name = "Computer";
            exec = "${pkgs.thunar}/bin/thunar computer:///";
          };

          "open-trash" = {
            name = "Trash";
            exec = "${pkgs.thunar}/bin/thunar trash:///";
          };
        };
      };
    };
  };
}
