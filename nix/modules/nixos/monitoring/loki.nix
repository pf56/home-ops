{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
with lib;
let
  cfg = config.roles.monitoring.loki;
in
{
  options = {
    roles.monitoring.loki = {
      enable = mkEnableOption (mdDoc "Enable Loki");

      port = mkOption {
        type = types.number;
        default = 3100;
      };

      grpcPort = mkOption {
        type = types.number;
        default = 9095;
      };
    };
  };

  config = mkIf cfg.enable {
    services.loki = {
      enable = true;

      configuration = {
        auth_enabled = false;
        server = {
          http_listen_port = cfg.port;
          grpc_listen_port = cfg.grpcPort;
        };

        common = {
          path_prefix = "/var/lib/loki";
          replication_factor = 1;

          ring = {
            instance_addr = "127.0.0.1";
            kvstore = {
              store = "inmemory";
            };
          };

          storage = {
            filesystem = {
              chunks_directory = "/var/lib/loki/chunks";
              rules_directory = "/var/lib/loki/rules";
            };
          };
        };

        ingester = {
          chunk_idle_period = "1h";
          max_chunk_age = "1h";
          chunk_target_size = 1048576;
          chunk_retain_period = "30s";
        };

        schema_config = {
          configs = [
            {
              from = "2025-12-01";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
        };

        storage_config = {
          tsdb_shipper = {
            active_index_directory = "/var/lib/loki/tsdb-index";
            cache_location = "/var/lib/loki/tsdb-cache";
            cache_ttl = "24h";
          };
        };
      };
    };
  };
}
