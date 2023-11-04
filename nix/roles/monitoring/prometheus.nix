{ lib, pkgs, config, modulesPath, ... }:
with lib;
let cfg = config.roles.monitoring.prometheus;
in
{
  options = {
    roles.monitoring.prometheus = {
      enable = mkEnableOption (mdDoc "Enable prometheus");

      scrapeConfigs = mkOption {
        type = types.nullOr (
          (import (modulesPath + "/services/monitoring/prometheus/") {
            inherit config pkgs lib;
          }).options.services.prometheus.scrapeConfigs.type
        );
        #}).type.getSubOptions []).scrapeConfigs;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      scrapeConfigs = cfg.scrapeConfigs;
    };
  };
}
