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
              # left
              criteria = "LG Electronics 27GL850 912NTDV0N042";
              mode = "2560x1440@59.951000Hz";
              position = "1920,0";
            }
            {
              # main
              criteria = "LG Electronics LG ULTRAGEAR 101NTNHSV159";
              mode = "2560x1440@99.90002Hz";
              position = "4480,0";
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
