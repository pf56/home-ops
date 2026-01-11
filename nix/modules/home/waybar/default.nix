{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.waybar;
in
{
  options.modules.waybar = {
    enable = mkOption {
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
            "niri/workspaces"
          ];

          modules-center = [
            "niri/window"
          ];

          modules-right = [
            "cpu"
            "temperature"
            "memory"
            "disk"
            "tray"
            "clock"
          ];

          cpu = {
            format = " {usage}%";
            interval = 5;
          };

          memory = {
            format = " {percentage}%";
            interval = 10;
          };

          disk = {
            format = "󰋊 {percentage_used}%";
            unit = "GB";
            tooltip-format = "{free} / {total}";
          };

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
                weeks = "<span color='#99ffdd'><b>W{:%V}</b></span>";
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
        .modules-left, .modules-center, .modules-right {
          margin-top: 5px;
        }

        .modules-left {
          margin-left: 5px;
        }

        .modules-left #workspaces button {
          padding: 2px;
          min-width: 28px;
          border: none;
          border-radius: 0;
        }

        .modules-left #workspaces button.active,
        .modules-left #workspaces button.focused {
          background-color: @base01;
          border-bottom: none;
        }
      '';
    };
  };
}
