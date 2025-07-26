{
  config,
  pkgs,
  lib,
  inputs,
  flake,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
    flake.nixosModules.host-base
    flake.nixosModules.monitoring
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "monitoring";
  networking.firewall.allowedTCPPorts = [
    80
    443
    1514
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  services.prometheus.exporters = {
    node = {
      enable = true;
      port = 9100;
      enabledCollectors = [ "systemd" ];
    };
  };

  roles.monitoring = {
    dashboard = {
      enable = true;
      domain = "dashboard.internal.paulfriedrich.me";
      nginx = {
        forceSSL = true;
        quic = true;

        enableACME = true;
        acmeRoot = null;
      };
    };

    prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "monitoring.internal.paulfriedrich.me";
          static_configs = [
            {
              targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
            }
          ];
        }
        {
          job_name = "vyos01.internal.paulfriedrich.me";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = [ "10.0.60.1:9273" ];
            }
          ];
        }
        {
          job_name = "router.vultr.internal.paulfriedrich.me";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = [ "router.vultr.internal.paulfriedrich.me:9273" ];
            }
          ];
        }
      ];
    };

    loki = {
      enable = true;
    };

    promtail = {
      enable = true;

      scrapeConfigs = [
        {
          job_name = "journal";

          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "monitoring";
            };
          };

          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
          ];
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
    recommendedBrotliSettings = true;
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
