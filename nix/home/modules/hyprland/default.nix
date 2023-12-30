{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.hyprland;
in
{
  options.modules.hyprland = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      extraConfig = ''
        monitor = eDP-1,1920x1080,0x0,1
        monitor = HDMI-A-1,2560x1440,1920x0,1
        monitor = desc:LG Electronics 27GL850 912NTDV0N042,2560x1440@99,4480x0,1
        monitor = ,preferred,auto,1

        bindl = ,switch:on:Lid Switch,exec,hyprctl keyword monitor "eDP-1,1920x1080,0x0,1"
        bindl = ,switch:off:Lid Switch,exec,hyprctl keyword monitor "eDP-1,disable"

        $mod = SUPER
        
        bind = $mod, left, movefocus, l
        bind = $mod, right, movefocus, r
        bind = $mod, up, movefocus, u
        bind = $mod, down, movefocus, d

        bind = $mod SHIFT, left, movewindow, l
        bind = $mod SHIFT, right, movewindow, r
        bind = $mod SHIFT, up, movewindow, u
        bind = $mod SHIFT, down, movewindow, d

        bind = $mod, 1, workspace, 1
        bind = $mod, 2, workspace, 2
        bind = $mod, 3, workspace, 3
        bind = $mod, 4, workspace, 4
        bind = $mod, 5, workspace, 5
        bind = $mod, 6, workspace, 6
        bind = $mod, 7, workspace, 7
        bind = $mod, 8, workspace, 8
        bind = $mod, 9, workspace, 9
        bind = $mod, 0, workspace, 0

        bind = $mod SHIFT, 1, movetoworkspace, 1
        bind = $mod SHIFT, 2, movetoworkspace, 2
        bind = $mod SHIFT, 3, movetoworkspace, 3
        bind = $mod SHIFT, 4, movetoworkspace, 4
        bind = $mod SHIFT, 5, movetoworkspace, 5
        bind = $mod SHIFT, 6, movetoworkspace, 6
        bind = $mod SHIFT, 7, movetoworkspace, 7
        bind = $mod SHIFT, 8, movetoworkspace, 8
        bind = $mod SHIFT, 9, movetoworkspace, 9
        bind = $mod SHIFT, 0, movetoworkspace, 0

        bind = $mod SHIFT, Q, killactive
        bind = $mod, F, fullscreen, 1
        bind = $mod SHIFT, F, fullscreen, 0
        bind = $mod, RETURN, exec, alacritty
        bind = $mod, D, exec, wofi

        general {
          resize_on_border = true
        }

        input {
          kb_layout = eu
          sensitivity = 0.2
          accel_profile = flat

          touchpad {
            natural_scroll = true
            middle_button_emulation = true
          }
        }

        misc {
          vrr = 1
          disable_hyprland_logo = true
        } 
      '';

      plugins = [ ];
    };

    home = {
      sessionVariables = {
        #        WLR_NO_HARDWARE_CURSORS = "1";
        WLR_RENDERER_ALLOW_SOFTWARE = "1";
      };
    };
  };
}
