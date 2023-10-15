{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../base/configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "monitoring";
  networking.firewall.allowedTCPPorts = [ 80 443 1514 ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  services.grafana = {
    enable = true;

    settings = {
      server = {
        domain = "grafana.internal.paulfriedrich.me";
        http_addr = "127.0.0.1";
        http_port = 3000;
      };
    };
  };

  services.prometheus = {
    enable = true;
    port = 9090;

    scrapeConfigs = [
      {
        job_name = "monitoring.internal.paulfriedrich.me";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "vyos01.internal.paulfriedrich.me";
        scrape_interval = "15s";
        static_configs = [{
          targets = [ "10.0.60.1:9273" ];
        }];
      }
    ];

    exporters = {
      node = {
        enable = true;
        port = 9100;
        enabledCollectors = [ "systemd" ];
      };
    };
  };

  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;
      server = {
        http_listen_port = 3100;
        grpc_listen_port = 9095;
      };

      common = {
        instance_addr = "127.0.0.1";
        path_prefix = "/var/lib/loki";
        storage = {
          filesystem = {
            chunks_directory = "/var/lib/loki/chunks";
            rules_directory = "/var/lib/loki/rules";
          };
        };
        replication_factor = 1;
        ring = {
          kvstore = {
            store = "inmemory";
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
        configs = [{
          from = "2023-10-01";
          store = "boltdb-shipper";
          object_store = "filesystem";
          schema = "v11";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper-active";
          cache_location = "/var/lib/loki/boltdb-shipper-cache";
          cache_ttl = "24h";
          shared_store = "filesystem";
        };
      };
    };
  };

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

      clients = [{
        url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
      }];

      scrape_configs = [
        {
          job_name = "journal";

          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "monitoring";
            };
          };

          relabel_configs = [{
            source_labels = [ "__journal__systemd_unit" ];
            target_label = "unit";
          }];
        }
        {
          job_name = "syslog";
          syslog = {
            listen_address = "0.0.0.0:1514";
            labels = {
              job = "syslog";
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__syslog_message_hostname" ];
              target_label = "host";
            }
            {
              source_labels = [ "__syslog_message_hostname" ];
              target_label = "hostname";
            }
            {
              source_labels = [ "__syslog_message_severity" ];
              target_label = "level";
            }
            {
              source_labels = [ "__syslog_message_app_name" ];
              target_label = "application";
            }
            {
              source_labels = [ "__syslog_message_facility" ];
              target_label = "facility";
            }
            {
              source_labels = [ "__syslog_connection_hostname" ];
              target_label = "connection_hostname";
            }
          ];
        }
      ];
    };
  };

  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;

    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedZstdSettings = true;
    recommendedBrotliSettings = true;

    upstreams = {
      "grafana" = {
        servers = {
          "127.0.0.1:${toString config.services.grafana.settings.server.http_port}" = { };
        };
      };
    };

    virtualHosts.${config.services.grafana.settings.server.domain} = {
      forceSSL = true;
      quic = true;

      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "http://grafana";
      };

      locations."/api/live" = {
        proxyPass = "http://grafana";
        proxyWebsockets = true;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme" + "@" + "mail" + ".paulfriedrich." + "me";
    defaults.dnsProvider = "cloudflare";
    defaults.dnsResolver = "1.1.1.1:53";
    defaults.credentialsFile = config.sops.secrets.acme_credentials.path;
  };

  sops = {
    secrets = {
      acme_credentials = { };
    };
  };

  lollypops.deployment.local-evaluation = true;
  system.stateVersion = "23.05";
}
