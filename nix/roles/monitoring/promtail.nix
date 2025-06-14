{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
with lib;
let
  cfg = config.roles.monitoring.promtail;
in
{
  options = {
    roles.monitoring.promtail = {
      enable = mkEnableOption (mdDoc "Enable promtail");

      scrapeConfigs = mkOption {
        type = (pkgs.formats.json { }).type;
      };
    };
  };

  config = mkIf cfg.enable {
    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 3101;
          grpc_listen_port = 0;
        };

        positions = {
          filename = "/tmp/positions.yaml";
        };

        clients = mkIf (config.roles.monitoring.loki.enable) [
          {
            url = "http://127.0.0.1:${toString config.roles.monitoring.loki.port}/loki/api/v1/push";
          }
        ];

        scrape_configs = cfg.scrapeConfigs;
      };
    };
  };
}
