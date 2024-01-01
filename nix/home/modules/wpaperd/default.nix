{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.wpaperd;
in
{
  options.modules.wpaperd = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    programs.wpaperd = {
      enable = true;

      settings = {
        default = {
          path = ./wallpapers/wild.png;
        };
      };
    };

    systemd.user.services.wpaperd = {
      Unit.Description = "wpaperd wallpaper daemon";
      Install.WantedBy = [ "graphicall-session.target" ];
      Service.ExecStart = "${pkgs.wpaperd}/bin/wpaperd --no-daemon";
    };
  };
}
