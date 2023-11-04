{ lib, pkgs, config, modulesPath, ... }:
with lib;
let cfg = config.roles.monitoring.dashboard;
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

      nginx = mkOption {
        type = types.nullOr (types.submodule
          (import (modulesPath + "/services/web-servers/nginx/vhost-options.nix") {
            inherit config lib;
          }));
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
