{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.niri;
in
{
  options.modules.niri = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.niri = {
      settings = {
        prefer-no-csd = true;
        screenshot-path = "~/Pictures/Screenshots/Screenshot-%Y-%m-%d-%H-%M-%S.png";
        xwayland-satellite.path = getExe pkgs.xwayland-satellite-unstable;

        input = {
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "0%";
          };

          keyboard = {
            xkb = {
              layout = "eu";
            };
          };

          mouse = {
            accel-speed = 0.2;
            accel-profile = "flat";
          };
        };

        outputs."DP-1" = {
          scale = 1;
          variable-refresh-rate = "on-demand";

          mode = {
            height = 1440;
            width = 3440;
          };
        };

        binds = {
          "Mod+Shift+Slash".action.show-hotkey-overlay = { };

          "Mod+Left".action.focus-column-left = { };
          "Mod+Right".action.focus-column-right = { };
          "Mod+Up".action.focus-window-up = { };
          "Mod+Down".action.focus-window-down = { };

          "Mod+Ctrl+Left".action.move-column-left = { };
          "Mod+Ctrl+Right".action.move-column-right = { };
          "Mod+Ctrl+Up".action.move-window-up = { };
          "Mod+Ctrl+Down".action.move-window-down = { };

          "Mod+Shift+Left".action.focus-monitor-left = { };
          "Mod+Shift+Down".action.focus-monitor-down = { };
          "Mod+Shift+Up".action.focus-monitor-up = { };
          "Mod+Shift+Right".action.focus-monitor-right = { };

          "Mod+Ctrl+Shift+Left".action.move-column-to-monitor-left = { };
          "Mod+Ctrl+Shift+Right".action.move-column-to-monitor-right = { };
          "Mod+Ctrl+Shift+Up".action.move-column-to-monitor-up = { };
          "Mod+Ctrl+Shift+Down".action.move-column-to-monitor-down = { };

          "Mod+Page_Up".action.focus-workspace-up = { };
          "Mod+Page_Down".action.focus-workspace-down = { };

          "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = { };
          "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = { };

          "Mod+Shift+Page_Up".action.move-workspace-up = { };
          "Mod+Shift+Page_Down".action.move-workspace-down = { };

          "Mod+WheelScrollUp" = {
            cooldown-ms = 150;
            action.focus-workspace-up = { };
          };

          "Mod+WheelScrollDown" = {
            cooldown-ms = 150;
            action.focus-workspace-down = { };
          };

          "Mod+Ctrl+WheelScrollUp" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-up = { };
          };

          "Mod+Ctrl+WheelScrollDown" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-down = { };
          };

          "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
          "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
          "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };
          "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };

          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Shift+1".action.move-column-to-workspace = 1;
          "Mod+Shift+2".action.move-column-to-workspace = 2;
          "Mod+Shift+3".action.move-column-to-workspace = 3;
          "Mod+Shift+4".action.move-column-to-workspace = 4;
          "Mod+Shift+5".action.move-column-to-workspace = 5;
          "Mod+Shift+6".action.move-column-to-workspace = 6;
          "Mod+Shift+7".action.move-column-to-workspace = 7;
          "Mod+Shift+8".action.move-column-to-workspace = 8;
          "Mod+Shift+9".action.move-column-to-workspace = 9;

          "Mod+W".action.toggle-column-tabbed-display = { };
          "Mod+Comma".action.consume-window-into-column = { };
          "Mod+Period".action.expel-window-from-column = { };

          "Mod+R".action.switch-preset-column-width = { };
          "Mod+Shift+R".action.reset-window-height = { };
          "Mod+C".action.center-column = { };
          "Mod+Shift+Space".action.toggle-window-floating = { };

          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          "Mod+F".action.maximize-column = { };
          "Mod+Shift+F".action.expand-column-to-available-width = { };
          "Mod+Ctrl+F".action.fullscreen-window = { };
          "Mod+Ctrl+Shift+F".action.toggle-windowed-fullscreen = { };

          "Print".action.screenshot = { };
          "Ctrl+Print".action.screenshot-screen = { };
          "Alt+Print".action.screenshot-window = { };

          "Mod+P".action.set-dynamic-cast-window = { };
          "Mod+Shift+P".action.set-dynamic-cast-monitor = { };
          "Mod+Ctrl+P".action.clear-dynamic-cast-target = { };

          "Super+L".action.spawn = "swaylock";
          "Mod+Return".action.spawn = "alacritty";
          "Mod+D".action.spawn = "wofi";

          "Ctrl+F9".action.spawn-sh = "${pkgs.discover-overlay}/bin/discover-overlay --rpc --toggle-mute";
          "Ctrl+F10".action.spawn-sh = "${pkgs.discover-overlay}/bin/discover-overlay --rpc --toggle-deaf";
          "Ctrl+F11".action.spawn-sh = "${pkgs.discover-overlay}/bin/discover-overlay --rpc --show";
          "Ctrl+Shift+F11".action.spawn-sh = "${pkgs.discover-overlay}/bin/discover-overlay --rpc --hide";

          "Mod+O" = {
            action.toggle-overview = { };
            repeat = false;
          };

          "Mod+Shift+Q" = {
            action.close-window = { };
            repeat = false;
          };
        };

        layout = {
          gaps = 10;
          center-focused-column = "on-overflow";
          background-color = "transparent";

          default-column-width = {
            proportion = 0.33333;
          };

          struts = {
            top = -5;
            bottom = -5;
            left = -5;
            right = -5;
          };

          border = {
            width = 2;
            active = {
              color = "#d8dee9";
            };
            inactive = {
              color = "#434c5e";
            };
            urgent = {
              color = "#bf616a";
            };
          };
        };

        hotkey-overlay = {
          skip-at-startup = true;
        };

        clipboard = {
          disable-primary = true;
        };

        gestures = {
          hot-corners.enable = false;
        };

        layer-rules = [
          {
            matches = [ { namespace = "^wpaperd-DP-1$"; } ];
            place-within-backdrop = true;
          }
          {
            matches = [ { namespace = "^notifications$"; } ];
            block-out-from = "screencast";
          }
          {
            matches = [ { namespace = "^wofi$"; } ];
            shadow.enable = true;
          }
        ];

        window-rules = [
          {
            matches = [ { is-window-cast-target = true; } ];
            focus-ring = {
              enable = true;
              active.color = "#f38ba8";
              inactive.color = "#7d0d2d";
            };

            border = {
              enable = true;
              inactive.color = "#7d0d2d";
            };
          }
          {
            matches = [
              {
                app-id = "librewolf$";
                title = "Picture-in-Picture$";
              }
            ];

            open-floating = true;

            default-column-width = {
              fixed = 711;
            };

            default-window-height = {
              fixed = 400;
            };
          }
          {
            matches = [
              { app-id = "discord$"; }
              { app-id = "thunderbird$"; }
            ];

            block-out-from = "screencast";
          }
        ];
      };
    };
  };
}
