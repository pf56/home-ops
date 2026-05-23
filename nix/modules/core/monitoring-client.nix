{ den, lib, ... }:
{
  den.aspects.monitoring-client = {
    nixos =
      { lib, config, ... }:
      let
        cfg = config.roles.monitoring.alloy;
      in
      {
        options.roles.monitoring.alloy = {
          enable = lib.mkEnableOption (lib.mdDoc "Enable Grafana Alloy");

          lokiBaseUrl = lib.mkOption {
            type = lib.types.str;
            default = "http://dashboard.internal.paulfriedrich.me:3100";
            description = lib.mdDoc ''
              The base URL of the Loki push endpoint.
            '';
          };

          prometheusBaseUrl = lib.mkOption {
            type = lib.types.str;
            default = "http://dashboard.internal.paulfriedrich.me:9090";
            description = lib.mdDoc ''
              The base URL of the Prometheus write endpoint.
            '';
          };
        };

        config = lib.mkMerge [
          {
            roles.monitoring.alloy.enable = lib.mkDefault true;
          }
          (lib.mkIf cfg.enable {
            services.alloy = {
              enable = true;
              configPath = "/etc/alloy";
            };

            environment.etc."alloy/config.alloy".text = ''
              loki.write "monitoring" {
                endpoint {
                  url = "${cfg.lokiBaseUrl}/loki/api/v1/push"
                }
              }

              prometheus.remote_write "monitoring" {
                endpoint {
                  url = "${cfg.prometheusBaseUrl}/api/v1/write"
                }
              }

              local.file_match "local_files" {
                path_targets = []
                sync_period = "5s"
              }

              loki.source.file "log_scrape" {
                targets       = local.file_match.local_files.targets
                forward_to    = [loki.process.filter_logs.receiver]
                tail_from_end = true
              }

              loki.process "filter_logs" {
                forward_to = [loki.write.monitoring.receiver]
              }

              loki.source.journal "journal" {
                forward_to    = [loki.process.journal.receiver]
                relabel_rules = loki.relabel.journal.rules
                labels = {
                  "job" = "systemd-journal",
                }
              }

              loki.relabel "journal" {
                forward_to = []

                rule {
                  source_labels = ["__journal__systemd_unit"]
                  target_label  = "unit"
                }

                rule {
                  source_labels = ["__journal__boot_id"]
                  target_label  = "boot_id"
                }

                rule {
                  source_labels = ["__journal__transport"]
                  target_label  = "transport"
                }

                rule {
                  source_labels = ["__journal_priority_keyword"]
                  target_label  = "level"
                }

                rule {
                  source_labels = ["__journal__hostname"]
                  target_label  = "instance"
                }
              }

              loki.process "journal" {
                stage.match {
                  selector = "{job=\"systemd-journal\",transport=\"kernel\"} |= \"nftables-\""

                  stage.static_labels {
                    values = {
                      unit = "nftables",
                    }
                  }
                }

                forward_to = [loki.write.monitoring.receiver]
              }

              prometheus.exporter.unix "node" { }

              prometheus.scrape "linux_node" {
                targets         = prometheus.exporter.unix.node.targets
                forward_to      = [prometheus.relabel.filter_metrics.receiver]
                scrape_interval = "10s"
              }

              prometheus.relabel "filter_metrics" {
                forward_to = [prometheus.remote_write.monitoring.receiver]
              }
            '';
          })
        ];
      };
  };
}
