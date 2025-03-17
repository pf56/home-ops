{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.kanshi;
in
{
  options.modules.kanshi = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    services.kanshi = {
      enable = true;

      # defaults to sway
      systemdTarget = "graphical-session.target";

      settings = [
        {
          profile.name = "home";
          profile.outputs = [
            {
              # main
              criteria = "Microstep MPG341CX OLED Unknown";
              mode = "3440x1440@239.998993Hz";
              position = "0,0";
            }
          ];
        }
      ];
    };
  };
}
