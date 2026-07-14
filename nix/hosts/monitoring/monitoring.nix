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
          6050
          6051
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

        services.vector = {
          enable = true;

          settings = {
            sources.talos_service_logs = {
              type = "socket";
              mode = "tcp";
              address = "0.0.0.0:6051";
              host_key = "__host";
              permit_origin = [
                "10.0.60.20/32"
                "10.0.60.21/32"
                "10.0.60.22/32"
                "10.0.60.23/32"
                "10.0.60.24/32"
                "10.0.60.25/32"
              ];
              framing.method = "newline_delimited";
              decoding.codec = "json";
            };

            sources.talos_kernel_logs = {
              type = "socket";
              mode = "tcp";
              address = "0.0.0.0:6050";
              host_key = "__host";
              permit_origin = [
                "10.0.60.20/32"
                "10.0.60.21/32"
                "10.0.60.22/32"
                "10.0.60.23/32"
                "10.0.60.24/32"
                "10.0.60.25/32"
              ];
              framing.method = "newline_delimited";
              decoding.codec = "json";
            };

            transforms.talos_service_enrich = {
              type = "remap";
              inputs = [ "talos_service_logs" ];
              source = ''
                .service = ."talos-service"
                .level = ."talos-level"
                .timestamp = parse_timestamp!(."talos-time", format: "%+")
                .message = .msg
              '';
            };

            transforms.talos_kernel_enrich = {
              type = "remap";
              inputs = [ "talos_kernel_logs" ];
              source = ''
                .cluster = "internal-paulfriedrich-me-prod"
                .level = ."talos-level"
                .timestamp = parse_timestamp!(."talos-time", format: "%+")
                .message = .msg
              '';
            };

            sinks.talos_service = {
              type = "loki";
              inputs = [ "talos_service_enrich" ];
              endpoint = "http://127.0.0.1:3100";
              encoding.codec = "json";
              labels = {
                cluster = "{{ cluster }}";
                node = "{{ node }}";
                service = "{{ service }}";
                level = "{{ level }}";
              };
            };

            sinks.talos_kernel = {
              type = "loki";
              inputs = [ "talos_kernel_enrich" ];
              endpoint = "http://127.0.0.1:3100";
              encoding.codec = "json";
              labels = {
                cluster = "{{ cluster }}";
                node = "{{ node }}";
                facility = "{{ facility }}";
                level = "{{ level }}";
              };
            };
          };
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
