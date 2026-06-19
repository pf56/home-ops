{ inputs, lib, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia/legacy-v4";
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
      { ... }:
      {
        imports = [
          inputs.noctalia.homeModules.default
        ];

        programs.noctalia-shell = {
          enable = true;

          plugins = {
            sources = [
              {
                enabled = true;
                name = "Official Noctalia Plugins";
                url = "https://github.com/noctalia-dev/noctalia-plugins";
              }
            ];

            states = {
              niri-workspaces = {
                enabled = true;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
            };

            version = 2;
          };

          settings = {
            appLauncher = {
              customLaunchPrefixEnabled = true;
              customLaunchPrefix = "systemd-run --user --scope --collect --";
            };

            bar = {
              enableExclusionZoneInset = false;
              fontScaling = 1.05;
              outerCorners = false;
              showCapsule = false;
              widgetSpacing = 0;

              widgets = {
                center = [
                  {
                    id = "ActiveWindow";
                    maxWidth = 1000;
                  }
                ];
                left = [
                  {
                    id = "Workspace";
                    labelMode = "index+name";
                    pillSize = 0.65;
                  }
                ];
                right = [
                  {
                    id = "Tray";
                    colorizeIcons = false;
                    pinned = [
                      "Discord"
                    ];
                  }
                  {
                    id = "NotificationHistory";
                  }
                  {
                    id = "Volume";
                    middleClickCommand = "pwvucontrol || pavucontrol";
                  }
                  {
                    id = "SystemMonitor";
                    showCpuTemp = true;
                    showCpuUsage = true;
                    showDiskUsage = true;
                    showGpuTemp = true;
                    showMemoryUsage = true;
                  }
                  {
                    id = "Clock";
                    formatHorizontal = "yyyy-MM-dd HH:mm:ss";
                  }
                  {
                    id = "ControlCenter";
                  }
                ];
              };
            };

            general = {
              enableShadows = true;
              shadowDirection = "center";
              shadowOffsetX = 0;
              shadowOffsetY = 0;
            };

            idle = {
              enable = true;
            };

            location = {
              autoLocate = true;
              firstDayOfWeek = 1;
              hideWeatherCityName = true;
              showWeekNumberInCalendar = true;
              weatherEnabled = true;
            };

            systemMonitor = {
              enableDgpuMonitoring = true;
            };

            wallpaper = {
              enable = true;
            };
          };
        };
      };
  };
}
