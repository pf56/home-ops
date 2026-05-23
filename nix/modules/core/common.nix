{ den, lib, ... }:
{
  den.aspects.common =
    {
      user ? null,
      ...
    }:
    {
      includes = [ den.aspects.monitoring-client ];

      nixos =
        {
          pkgs,
          config,
          lib,
          ...
        }:
        {
          networking.networkmanager.enable = true;
          time.timeZone = "Europe/Berlin";

          # system packages
          environment.systemPackages = with pkgs; [
            git
            gnupg
            pavucontrol
            pinentry-curses
            gedit
            easyeffects
            qpwgraph
          ];

          programs.dconf.enable = true;
          programs.zsh.enable = true;
          programs.ydotool.enable = true;

          # Select internationalisation properties.
          i18n = {
            defaultLocale = "en_US.UTF-8";
            supportedLocales = [
              "en_US.UTF-8/UTF-8"
              "de_DE.UTF-8/UTF-8"
            ];
          };

          services.fwupd.enable = true;

          services.dbus.enable = true;
          services.dbus.packages = with pkgs; [
            gcr
            dconf
          ];

          services.pcscd.enable = true;

          services.bcachefs.autoScrub = {
            enable = lib.any (fs: fs.fsType == "bcachefs") (lib.attrValues config.fileSystems);
          };

          services.angrr = {
            enable = true;

            settings = {
              temporary-root-policies = {
                direnv = {
                  path-regex = "/\\.direnv/";
                  period = "14d";
                };

                result = {
                  path-regex = "/result[^/]*$";
                  period = "3d";
                };
              };

              profile-policies.user = {
                enable = false;
                profile-paths = [ ];
              };

              profile-policies.system = {
                enable = false;
                profile-paths = [ ];
              };
            };
          };

          # enable scanner/printer
          hardware.sane.enable = true;
          services.printing.enable = true;

          programs.kdeconnect.enable = true;

          security.polkit.enable = true;
          systemd = {
            user.services.polkit-gnome-authentication-agent-1 = {
              description = "polkit-gnome-authentication-agent-1";
              wantedBy = [ "graphical-session.target" ];
              wants = [ "graphical-session.target" ];
              after = [ "graphical-session.target" ];
              serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
              };
            };
          };

          environment.pathsToLink = [
            "/share/xdg-desktop-portal"
            "/share/applications"
          ];

          networking.firewall = {
            enable = true;
            trustedInterfaces = [
              "virbr0"
            ];
          };

          nixpkgs.config.allowUnfree = true;
          nix = {
            package = pkgs.nixVersions.stable;

            settings = {
              secret-key-files = /var/cache-priv-key.pem;
              auto-optimise-store = true;
              substituters = [ "https://ghostty.cachix.org" ];
              trusted-public-keys = [
                "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
              ];
            };

            gc = {
              automatic = true;
              options = "--delete-older-than 30d";
            };

            extraOptions = ''
              experimental-features = nix-command flakes
            '';
          };

          users.users = lib.optionalAttrs (user != null) {
            ${user.userName} = {
              extraGroups = [
                "scanner"
                "lp"
                "input"
                config.programs.ydotool.group
              ];
            };
          };
        };
    };
}
