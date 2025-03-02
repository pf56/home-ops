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
          # internal display
          output.criteria = "Lenovo Group Limited 0x40BA Unknown";
          output.mode = "1920x1080@59.977001Hz";
          output.position = "0,0";
          output.status = "enable";
        }
        {
          profile.name = "home";
          profile.outputs = [
            {
              # internal display
              criteria = "Lenovo Group Limited 0x40BA Unknown";
              status = "disable";
            }
            {
              # main
              criteria = "Microstep MPG341CX OLED Unknown";
              mode = "3440x1440@59.973000Hz";
              position = "0,0";
            }
          ];
        }
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              # internal display
              criteria = "Lenovo Group Limited 0x40BA Unknown";
            }
          ];
        }
      ];
    };
  };
}
