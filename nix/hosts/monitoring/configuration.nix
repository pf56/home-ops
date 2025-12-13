{
  config,
  pkgs,
  lib,
  inputs,
  flake,
  ...
}:

{
  imports = with inputs; [
    disko.nixosModules.disko
    ./disk-config.nix
    nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }
    sops-nix.nixosModules.sops
    flake.nixosModules.server-base
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "monitoring";
  networking.firewall.allowedTCPPorts = [
    80
    443
    1514
    9090
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  roles.monitoring = {
    dashboard =
      let
        grafanaDashboardsLib = inputs.grafana-dashboards.lib { inherit pkgs; };
      in
      {
        enable = true;
        domain = "dashboard.internal.paulfriedrich.me";

        nginx = {
          forceSSL = true;
          quic = true;

          enableACME = true;
          acmeRoot = null;
        };

        dashboards = [
          (grafanaDashboardsLib.dashboardEntry {
            name = "node-exporter-full";
            path = grafanaDashboardsLib.fetchDashboard {
              name = "node-exporter-full";
              hash = "sha256-5Wk9SD7jaLBtSzYBnTuwANt9LAkAq6ddu7bRO/CGP38=";
              id = 1860;
              version = 42;
            };
          }).options.path
          (grafanaDashboardsLib.dashboardEntry {
            name = "kea-dhcp";
            path = grafanaDashboardsLib.fetchDashboard {
              name = "kea-dhcp";
              hash = "sha256-hLygasxxeEVi45gD3QQQUcmCZdqu3rgKB/dSSFpLpDM=";
              id = 12688;
              version = 4;
            };
            transformations = grafanaDashboardsLib.fillTemplating [{ key = "DS_PROMETHEUS"; value = "PBFA97CFB590B2093"; } ];
          }).options.path
        ];
      };

    prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "monitoring.internal.paulfriedrich.me";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
            }
          ];
        }
        {
          # Kea exporter
          job_name = "router.internal.paulfriedrich.me";
          static_configs = [
            {
              targets = [ "10.0.60.1:9547" ];
            }
          ];
        }
      ];
    };

    loki = {
      enable = true;
    };

    alloy = {
      enable = true;
      lokiBaseUrl = "http://localhost:${toString config.roles.monitoring.loki.port}";
      prometheusBaseUrl = "http://localhost:${toString config.roles.monitoring.prometheus.port}";
    };
  };

  services.nginx = {
    enable = true;
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

  system.stateVersion = "25.11";
}
