{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.river;
in
{
  options.modules.river = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.river = {
      enable = true;

      settings =
        let
          mod = "Super";
        in
        {
          declare-mode = [
            "normal"
            "float"
          ];

          map = {
            normal = {
              "${mod} 1" = "set-focused-tags 1";
              "${mod} 2" = "set-focused-tags 2";
              "${mod} 3" = "set-focused-tags 4";
              "${mod} 4" = "set-focused-tags 8";
              "${mod} 5" = "set-focused-tags 16";
              "${mod} 6" = "set-focused-tags 32";
              "${mod} 7" = "set-focused-tags 64";
              "${mod} 8" = "set-focused-tags 128";
              "${mod} 9" = "set-focused-tags 256";

              "${mod}+Shift 1" = "set-view-tags 1";
              "${mod}+Shift 2" = "set-view-tags 2";
              "${mod}+Shift 3" = "set-view-tags 4";
              "${mod}+Shift 4" = "set-view-tags 8";
              "${mod}+Shift 5" = "set-view-tags 16";
              "${mod}+Shift 6" = "set-view-tags 32";
              "${mod}+Shift 7" = "set-view-tags 64";
              "${mod}+Shift 8" = "set-view-tags 128";
              "${mod}+Shift 9" = "set-view-tags 256";

              "${mod}+Control 1" = "toggle-focused-tags 1";
              "${mod}+Control 2" = "toggle-focused-tags 2";
              "${mod}+Control 3" = "toggle-focused-tags 4";
              "${mod}+Control 4" = "toggle-focused-tags 8";
              "${mod}+Control 5" = "toggle-focused-tags 16";
              "${mod}+Control 6" = "toggle-focused-tags 32";
              "${mod}+Control 7" = "toggle-focused-tags 64";
              "${mod}+Control 8" = "toggle-focused-tags 128";
              "${mod}+Control 9" = "toggle-focused-tags 256";

              "${mod}+Shift+Control 1" = "toggle-view-tags 1";
              "${mod}+Shift+Control 2" = "toggle-view-tags 2";
              "${mod}+Shift+Control 3" = "toggle-view-tags 4";
              "${mod}+Shift+Control 4" = "toggle-view-tags 8";
              "${mod}+Shift+Control 5" = "toggle-view-tags 16";
              "${mod}+Shift+Control 6" = "toggle-view-tags 32";
              "${mod}+Shift+Control 7" = "toggle-view-tags 64";
              "${mod}+Shift+Control 8" = "toggle-view-tags 128";
              "${mod}+Shift+Control 9" = "toggle-view-tags 256";

              "${mod} Left" = "focus-view left";
              "${mod} Right" = "focus-view right";
              "${mod} Up" = "focus-view up";
              "${mod} Down" = "focus-view down";
              "${mod} Page_Up" = "focus-view next";
              "${mod} Page_Down" = "focus-view previous";

              "${mod}+Shift Left" = "swap left";
              "${mod}+Shift Right" = "swap right";
              "${mod}+Shift Up" = "swap up";
              "${mod}+Shift Down" = "swap down";

              "${mod}+Control Left" = "focus-output left";
              "${mod}+Control Right" = "focus-output right";
              "${mod}+Control Up" = "focus-output up";
              "${mod}+Control Down" = "focus-output down";

              "${mod}+Shift+Control Left" = "send-to-output left";
              "${mod}+Shift+Control Right" = "send-to-output right";
              "${mod}+Shift+Control Up" = "send-to-output up";
              "${mod}+Shift+Control Down" = "send-to-output down";

              "${mod} F" = "zoom";
              "${mod}+Shift F" = "toggle-fullscreen";
              "${mod}+Shift Space" = "toggle-float";
              "${mod}+Shift Q" = "close";

              "${mod} Return" = "spawn ghostty";
              "${mod} D" = "spawn wofi";

              "${mod} R" = "enter-mode float";
              "${mod} T" = "send-layout-cmd wideriver '--layout-toggle'";
              "${mod}+Shift T" = "spawn 'pkill -SIGUSR1 waybar'";
            };

            float = {
              "${mod} Left" = "move left 100";
              "${mod} Right" = "move right 100";
              "${mod} Up" = "move up 100";
              "${mod} Down" = "move down 100";

              "Shift Left" = "resize horizontal -100";
              "Shift Right" = "resize horizontal 100";
              "Shift Up" = "resize vertical -100";
              "Shift Down" = "resize vertical 100";

              "Alt Left" = "snap left";
              "Alt Right" = "snap right";
              "Alt Up" = "snap up";
              "Alt Down" = "snap down";

              "None Escape" = "enter-mode normal";
            };
          };

          rule-add = {
            "-app-id" = {
              "'librewolf'" = {
                "-title" = {
                  "'Picture-in-Picture'" = [
                    "float"
                    "dimensions 711 400"
                  ];
                };
              };
            };
          };

          focus-follows-cursor = "normal";
          default-layout = "wideriver";

          keyboard-layout = "eu";
          input = {
            pointer-1133-16568-Logitech_PRO_X_2_DEX = {
              accel-profile = "flat";
              pointer-accel = 0.2;
            };
          };
        };

      extraSessionVariables = {
        XDG_CURRENT_DESKTOP = "river";
      };

      extraConfig = ''
        ${pkgs.wideriver}/bin/wideriver \
            --layout left \
            --layout-alt monocle \
            --stack dwindle \
            --inner-gaps 5 \
            --smart-gaps \
          > ""/tmp/wideriver.''${XDG_VTNR}.''${USER}.log 2>&1 &
      '';
    };
  };
}
