{ den, inputs, ... }:
{
  den.aspects.monitoring = {
    includes = [
      den.aspects.bootable
      den.aspects.server-base
      den.aspects.monitoring-server
    ];

    nixos =
      { config, pkgs, ... }:
      {
        imports = [
          ./_disk-config.nix
          { config.facter.reportPath = ./facter.json; }
        ];

        networking.hostName = "monitoring";

        networking.firewall.allowedTCPPorts = [
          80
          443
          1514
          3100
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
                  transformations = grafanaDashboardsLib.fillTemplating [
                    {
                      key = "DS_PROMETHEUS";
                      value = "PBFA97CFB590B2093";
                    }
                  ];
                }).options.path
                # (pkgs.fetchurl {
                #   name = "node-exporter-full.json";
                #   url = "https://grafana.com/api/dashboards/1860/revisions/45/download";
                #   hash = "sha256-GExrdAnzBtp1Ul13cvcZRbEM6iOtFrXXjEaY6g6lGYY=";
                # })
                # (pkgs.fetchurl {
                #   name = "kea-dhcp.json";
                #   url = "https://grafana.com/api/dashboards/12688/revisions/4/download";
                #   hash = "sha256-/Uj5iqv1rAMYts+i2ELNsZeCc6J6cGqcnUWLFLryCOc=";
                # })
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
                job_name = "router.internal.paulfriedrich.me";
                static_configs = [
                  {
                    targets = [ "10.0.60.1:9547" ];
                  }
                ];
              }
            ];
          };

          loki.enable = true;
          alloy.enable = true;
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
          defaults.environmentFile = config.sops.secrets.acme_credentials.path;
        };

        sops.secrets.acme_credentials = { };

        system.stateVersion = "25.11";
      };
  };
}
