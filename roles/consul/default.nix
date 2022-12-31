{ lib, pkgs, config, ... }:
with lib;
let cfg = config.roles.consul;
in
{
  options = {
    roles.consul = {
      enable = mkEnableOption (mdDoc "Enable consul");

      server = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Whether the consul agent should run as a server.
        '';
      };

      datacenter = mkOption {
        type = types.str;
        default = "global";
        description = mdDoc ''
          The datacenter of the agent.
        '';
      };

      bootstrapExpect = mkOption {
        type = types.int;
        default = 1;
        description = mdDoc ''
          The number of servers to expect before bootstrapping.
        '';
      };

      retryJoin = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = mdDoc ''
          A list of servers to join with.
        '';
      };

      interface = mkOption {
        type = types.str;
        default = "";
        description = mdDoc ''
          The interface to use for binding.
        '';
      };

      webUi = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Whether to enable the web interface.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.consul = mkMerge [
      {
        enable = true;
        webUi = cfg.webUi;

        extraConfig = {
          server = cfg.server;
          datacenter = cfg.datacenter;
          addresses.http = "0.0.0.0";

          retry_join = cfg.retryJoin;
        };

        interface = {
          bind = cfg.interface;
          advertise = cfg.interface;
        };
      }
      (mkIf cfg.server {
        # server specific options
        extraConfig.bootstrap_expect = cfg.bootstrapExpect;
      })
    ];

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        8300 # RPC
        8301 # LAN Serf
        8302 # WAN Serf
        #8502  # gRPC
        8600 # DNS
      ] ++ (lib.optionals (cfg.webUi) [
        8500 # HTTP / web ui
        #8501  # HTTPS / web ui
      ]);

      allowedTCPPortRanges = [
        {
          # sidecar proxies
          from = 21000;
          to = 21255;
        }
      ];

      allowedUDPPorts = [
        8301 # LAN Serf
        8302 # WAN Serf
        8600 # DNS
      ];

      allowedUDPPortRanges = [
        {
          # sidecar proxies
          from = 21000;
          to = 21255;
        }
      ];
    };
  };
}
