{ den, lib, ... }:
{
  den.aspects.monitoring-server = {
    nixos =
      {
        lib,
        pkgs,
        config,
        modulesPath,
        ...
      }:
      let
        cfgDashboard = config.roles.monitoring.dashboard;
        cfgPrometheus = config.roles.monitoring.prometheus;
        cfgLoki = config.roles.monitoring.loki;

        dashboardDir = pkgs.symlinkJoin {
          name = "grafana-dashboards";
          paths = cfgDashboard.dashboards;
        };
      in
      {
        options.roles.monitoring = {
          dashboard = {
            enable = lib.mkEnableOption (lib.mdDoc "Enable the monitoring dashboard");

            domain = lib.mkOption {
              type = lib.types.str;
              default = "dashboard.internal.paulfriedrich.me";
              description = lib.mdDoc ''
                The domain of the dashboard.
              '';
            };

            dashboards = lib.mkOption {
              type = lib.types.listOf lib.types.path;
              default = [ ];
              description = lib.mdDoc ''
                List of paths to dashboards in JSON format.
              '';
            };

            nginx = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.submodule (
                  import (modulesPath + "/services/web-servers/nginx/vhost-options.nix") {
                    inherit config lib;
                  }
                )
              );
              default = null;
            };
          };

          prometheus = {
            enable = lib.mkEnableOption (lib.mdDoc "Enable Prometheus");

            port = lib.mkOption {
              type = lib.types.int;
              default = 9090;
            };

            scrapeConfigs = lib.mkOption {
              type = lib.types.nullOr (
                (import (modulesPath + "/services/monitoring/prometheus/") {
                  inherit config pkgs lib;
                }).options.services.prometheus.scrapeConfigs.type
              );
              default = [ ];
            };
          };

          loki = {
            enable = lib.mkEnableOption (lib.mdDoc "Enable Loki");

            port = lib.mkOption {
              type = lib.types.int;
              default = 3100;
            };

            grpcPort = lib.mkOption {
              type = lib.types.int;
              default = 9095;
            };
          };
        };

        config = lib.mkMerge [
          {
            roles.monitoring.prometheus.enable = lib.mkDefault true;
            roles.monitoring.loki.enable = lib.mkDefault true;
            roles.monitoring.dashboard.enable = lib.mkDefault true;
          }
          (lib.mkIf cfgPrometheus.enable {
            services.prometheus = {
              enable = true;
              port = cfgPrometheus.port;
              extraFlags = [ "--web.enable-remote-write-receiver" ];
              scrapeConfigs = cfgPrometheus.scrapeConfigs;
            };
          })
          (lib.mkIf cfgLoki.enable {
            services.loki = {
              enable = true;

              configuration = {
                auth_enabled = false;
                server = {
                  http_listen_port = cfgLoki.port;
                  grpc_listen_port = cfgLoki.grpcPort;
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
          })
          (lib.mkIf cfgDashboard.enable {
            services.grafana = {
              enable = true;

              settings.server = {
                domain = cfgDashboard.domain;
                http_addr = "127.0.0.1";
                http_port = 3000;
              };

              settings.security = {
                secret_key = "$__file{${config.sops.secrets."monitoring/grafana-secret-key".path}}";
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

            services.nginx = lib.mkIf (cfgDashboard.nginx != null) {
              enable = true;

              upstreams."monitoring-grafana".servers = {
                "127.0.0.1:${toString config.services.grafana.settings.server.http_port}" = { };
              };

              virtualHosts."${cfgDashboard.domain}" = lib.mkMerge [
                cfgDashboard.nginx
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

            sops.secrets = {
              "monitoring/grafana-secret-key" = {
                owner = "grafana";
              };
            };
          })
          (lib.mkIf cfgLoki.enable {
            roles.monitoring.alloy.lokiBaseUrl = lib.mkDefault "http://localhost:${toString cfgLoki.port}";
          })
          (lib.mkIf cfgPrometheus.enable {
            roles.monitoring.alloy.prometheusBaseUrl = lib.mkDefault "http://localhost:${toString cfgPrometheus.port}";
          })
        ];
      };
  };
}
