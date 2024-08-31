{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.waybar;
in
{
  options.modules.waybar = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        main = {
          position = "top";
          height = 30;
          spacing = 10;

          modules-left = [
            "river/tags"
            "river/mode"
          ];

          modules-center = [
          ];

          modules-right = [
            "battery"
            "tray"
            "clock"
          ];

          "river/tags" = {
            num-tags = 9;

            set-tags = [
              2147483649
              2147483650
              2147483652
              2147483656
              2147483664
              2147483680
              2147483712
              2147483776
              2147483904
            ];

            toggle-tags = [
              1
              2
              4
              8
              16
              32
              64
              128
              256
            ];
          };

          battery = { };

          clock = {
            timezone = "Europe/Berlin";
            locale = "de_DE.UTF-8";
            format = "{:%F %T}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            interval = 1;

            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "left";
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };

            actions = {
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };
        };
      };

      style = ''
        * {
          font-family: SauceCodePro NFM Medium;
          font-size: 13px;
        }
        
        window#waybar {
          background-color: #${config.colorScheme.palette.base00};
        }
        
        #tags button {
          margin: 0;
          padding: 0;
          min-width: 30px;

          border-radius: 0;
          color: #${config.colorScheme.palette.base04};
        }
        
        #tags button.focused {
          background-color: #${config.colorScheme.palette.base01};
        }
        
        #tags button.occupied {
          color: #${config.colorScheme.palette.base06};
        }
        
        #tags button.urgent {
          color: orange;
        }
      '';
    };
  };
}
