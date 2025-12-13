{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
with lib;
let
  cfg = config.roles.monitoring.prometheus;
in
{
  options = {
    roles.monitoring.prometheus = {
      enable = mkEnableOption (mdDoc "Enable prometheus");

      port = mkOption {
        type = types.number;
        default = 9090;
      };

      scrapeConfigs = mkOption {
        type = types.nullOr (
          (import (modulesPath + "/services/monitoring/prometheus/") {
            inherit config pkgs lib;
          }).options.services.prometheus.scrapeConfigs.type
        );
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = cfg.port;
      extraFlags = [ "--web.enable-remote-write-receiver" ];
      scrapeConfigs = cfg.scrapeConfigs;
    };
  };
}
