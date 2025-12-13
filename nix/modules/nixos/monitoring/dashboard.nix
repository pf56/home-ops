{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
with lib;
let
  cfg = config.roles.monitoring.dashboard;
  cfgPrometheus = config.roles.monitoring.prometheus;
  cfgLoki = config.roles.monitoring.loki;

  dashboardDir = pkgs.symlinkJoin {
    name = "grafana-dashboards";
    paths = cfg.dashboards;
  };
in
{
  options = {
    roles.monitoring.dashboard = {
      enable = mkEnableOption (mdDoc "Enable the monitoring dashboard");

      domain = mkOption {
        type = types.str;
        default = "dashboard.internal.paulfriedrich.me";
        description = mdDoc ''
          The domain of the dashboard.
        '';
      };

      dashboards = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = mdDoc ''
          List of paths to dashboards in JSON format.
        '';
      };

      nginx = mkOption {
        type = types.nullOr (
          types.submodule (
            import (modulesPath + "/services/web-servers/nginx/vhost-options.nix") {
              inherit config lib;
            }
          )
        );
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;

      settings = {
        server = {
          domain = cfg.domain;
          http_addr = "127.0.0.1";
          http_port = 3000;
        };
      };

      provision = {
        enable = true;
        dashboards.settings.providers = [
          {
            name = "dashboards";
            options = {
              path = dashboardDir;
              foldersFromFilesStructure = true;
            };
          }
        ];

        datasources.settings = {
          prune = true;
          datasources =
            lib.optionals cfgPrometheus.enable [
              {
                name = "Prometheus";
                type = "prometheus";
                url = "http://localhost:${toString cfgPrometheus.port}";
                isDefault = true;
                editable = false;
              }
            ]
            ++ lib.optionals cfgLoki.enable [
              {
                name = "Loki";
                type = "loki";
                url = "http://localhost:${toString cfgLoki.port}";
                editable = false;
              }
            ];
        };
      };
    };

    services.nginx = mkIf (cfg.nginx != null) {
      enable = true;

      upstreams."monitoring-grafana" = {
        servers = {
          "127.0.0.1:${toString config.services.grafana.settings.server.http_port}" = { };
        };
      };

      virtualHosts."${cfg.domain}" = mkMerge [
        cfg.nginx
        {
          forceSSL = true;
          quic = true;

          enableACME = true;
          acmeRoot = null;

          locations."/" = {
            proxyPass = "http://monitoring-grafana";
          };

          locations."/api/live" = {
            proxyPass = "http://monitoring-grafana";
            proxyWebsockets = true;
          };
        }
      ];
    };
  };
}
