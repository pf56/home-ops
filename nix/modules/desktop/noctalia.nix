{ inputs, lib, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.noctalia = {
    nixos =
      { config, ... }:
      {
        networking.networkmanager.enable = lib.mkDefault true;
        hardware.bluetooth.enable = lib.mkDefault true;
        services.tuned.enable = lib.mkDefault true;
        services.upower.enable = lib.mkDefault true;

        assertions = [
          {
            assertion = config.networking.networkmanager.enable;
            message = "den.aspects.noctalia requires networking.networkmanager.enable = true.";
          }
          {
            assertion = config.hardware.bluetooth.enable;
            message = "den.aspects.noctalia requires hardware.bluetooth.enable = true.";
          }
          {
            assertion = config.services.tuned.enable;
            message = "den.aspects.noctalia requires services.tuned.enable = true.";
          }
          {
            assertion = config.services.upower.enable;
            message = "den.aspects.noctalia requires services.upower.enable = true.";
          }
        ];

        nix.settings = {
          extra-substituters = [ "https://noctalia.cachix.org" ];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };
      };

    homeManager =
      { config, ... }:
      {
        imports = [
          inputs.noctalia.homeModules.default
        ];

        programs.noctalia = {
          enable = true;

          settings = {
            bar.default = {
              start = [ "workspaces" ];
              center = [ "active_window" ];
              end = [
                "tray"
                "notifications"
                "volume"
                "cpu"
                "ram"
                "temp"
                "sysmon"
                "clock"
                "session"
              ];
              margin_edge = 5;
              margin_ends = 5;
              radius = 0;
              shadow = false;
            };

            control_center = {
              sidebar = "full";
              sidebar_section = "full";
              shortcuts = [
                { type = "caffeine"; }
                { type = "notification"; }
                { type = "clipboard"; }
              ];
            };

            desktop_widgets.enabled = false;

            dock = {
              auto_hide = true;
              enabled = true;
              icon_size = 32;
              launcher_position = "start";
              margin_edge = 12;
              reserve_space = false;
              show_dots = true;
            };

            idle = {
              behavior_order = [
                "lock"
                "screen-off"
                "lock-and-suspend"
              ];
              behavior = {
                lock = {
                  action = "lock";
                  enabled = true;
                  timeout = 600.0;
                };
                "lock-and-suspend" = {
                  action = "lock_and_suspend";
                  enabled = false;
                  timeout = 900.0;
                };
                "screen-off" = {
                  action = "screen_off";
                  enabled = false;
                  timeout = 660.0;
                };
              };
            };

            shell = {
              clipboard_enabled = false;
              telemetry_enabled = false;
              panel = {
                control_center_placement = "floating";
                open_near_click_control_center = true;
              };
              screenshot.confirm_region = true;
            };

            theme = {
              builtin = "Nord";
              templates = {
                enable_builtin_templates = false;
                enable_community_templates = false;
              };
            };

            wallpaper = {
              enabled = true;
              default.path = config.stylix.image;
            };

            widget = {
              active_window = {
                enabled = true;
                max_length = 800;
              };
              clock.format = "{:%Y-%m-%d %H:%M:%S}";
              cpu.show_label = false;
              ram.show_label = false;
              sysmon = {
                show_label = false;
                stat = "disk_pct";
              };
              temp.show_label = false;
            };
          };
        };
      };
  };
}
