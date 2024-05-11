{ config, pkgs, lib, ... }:

let
  base00 = "#2e3440";
  base01 = "#3b4252";
  base02 = "#434c5e";
  base03 = "#4c566a";
  base04 = "#d8dee9";
  base05 = "#e5e9f0";
  base06 = "#eceff4";
  base07 = "#8fbcbb";
  base08 = "#88c0d0";
  base09 = "#81a1c1";
  base0A = "#5e81ac";
  base0B = "#bf616a";
  base0C = "#d08770";
  base0D = "#ebcb8b";
  base0E = "#a3be8c";
  base0F = "#b48ead";

  gsettings_schemas = pkgs.gsettings-desktop-schemas;
  gsettings_schemadir = "${gsettings_schemas}/share/gsettings-schemas/${gsettings_schemas.name}";

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme "Adwaita"
        gsettings set $gnome_schema icon-theme "Adwaita"
        gsettings set $gnome_schema cursor-theme "Adwaita"
      '';
  };

in
{
  home.packages = with pkgs; [
    grim
    slurp
    i3pystatus
    mako
    i3status
    glib
    gsettings-desktop-schemas
    gnome3.adwaita-icon-theme
    configure-gtk

    (python310Packages.py3status.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = with python3Packages;[ pytz tzlocal ] ++ oldAttrs.propagatedBuildInputs;
    }))
  ];

  home.sessionVariables = {
    XDG_DATA_DIRS = "${gsettings_schemadir}:$XDG_DATA_DIRS";
  };

  xdg.configFile."i3status/config".source = ./py3status.conf;

  wayland.windowManager.sway = {
    enable = false;
    xwayland = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "wofi --config ~/.config/wofi/config";

      fonts = {
        names = [ "SauceCodePro Nerd Font" ];
        style = "Medium";
        size = 11.0;
      };

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Alt+Left" = "move workspace to output left";
          "${modifier}+Alt+Right" = "move workspace to output right";
          "${modifier}+h" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Shift+0" = "move container to workspace number 10";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+F2" = "exec swaymsg 'output DP-5 toggle'";
        };

      modes = {
        resize = {
          Left = "resize shrink width 20px";
          Down = "resize grow height 20px";
          Up = "resize shrink height 20px";
          Right = "resize grow width 20px";
          Escape = "mode default";
          Return = "mode default";
        };
      };

      bars =
        let
          workspaceColor = border:
            (background:
              (text: {
                border = border;
                background = background;
                text = text;
              }));
        in
        [{
          position = "top";
          statusCommand = "py3status";
          workspaceNumbers = false;
          fonts = config.wayland.windowManager.sway.config.fonts;
          colors = {
            separator = base00;
            background = base01;
            statusline = base04;
            focusedWorkspace = workspaceColor base05 base0D base00;
            activeWorkspace = workspaceColor base05 base03 base00;
            inactiveWorkspace = workspaceColor base03 base01 base05;
            urgentWorkspace = workspaceColor base08 base08 base00;
            bindingMode = workspaceColor base00 base0A base00;
          };
        }];

      assigns = {
        "3" = [{ class = "^firefox$"; }];
        "9" = [{ class = "^discord$"; }];
        "10" = [{ class = "^Thunderbird$"; }];
      };

      colors =
        let
          swayColor = border:
            (background:
              (text:
                (indicator:
                  (childBorder: {
                    border = border;
                    background = background;
                    text = text;
                    indicator = indicator;
                    childBorder = childBorder;
                  }))));
        in
        {
          background = base07;
          focused = swayColor base05 base0D base00 base0D base0D;
          focusedInactive = swayColor base01 base01 base05 base03 base01;
          unfocused = swayColor base01 base00 base05 base01 base01;
          urgent = swayColor base08 base08 base00 base08 base08;
          placeholder = swayColor base00 base00 base05 base00 base00;
        };

      output = {
        # internal display
        eDP-1 = {
          resolution = "1920x1080";
          position = "0,180";
        };

        # external displays
        HDMI-A-1 = {
          resolution = "2560x1440";
          position = "1920,0";
        };

        DP-4 = {
          resolution = "2560x1440@99.900Hz";
          position = "4480,0";
        };

        DP-5 = {
          resolution = "2560x1440@99.900Hz";
          position = "4480,0";
        };

        DP-6 = {
          resolution = "2560x1440@99.900Hz";
          position = "4480,0";
        };
      };

      input = {
        # internal trackpoint
        "2:10:TTPS/2_Elan_TrackPoint" = {
          accel_profile = "flat";
          pointer_accel = "-1";
        };

        # internal touchpad
        "2:7:SynPS/2_Synaptics_TouchPad" = {
          accel_profile = "flat";
          pointer_accel = "0.2";
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };

        # Logitech Pro Superlight
        "1133:16531:Logitech_PRO_X" = {
          accel_profile = "flat";
          pointer_accel = "0.2";
        };

        # internal keyboard
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout = "eu";
        };

        # Ducky One 2
        "1241:854:DuckyChannel_International_Co.,_Ltd._Ducky_Keyboard" = {
          xkb_layout = "eu";
        };

        # Logitech K400
        "1133:16420:Logitech_K400" = {
          xkb_layout = "eu";
        };
      };
    };

    extraConfig = ''
      bindswitch --reload --locked lid:on output eDP-1 disable \n 
      bindswitch --reload --locked lid:off output eDP-1 enable \n
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP \n
      exec yubikey-touch-detector
    '';

    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export WLR_NO_HARDWARE_CURSORS=1
      configure-gtk
    '';
  };
}
