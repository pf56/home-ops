{ lib, pkgs, config, ... }:
with lib;
let cfg = config.roles.nomad;
in
{
  options = {
    roles.nomad = {
      enable = mkEnableOption (mdDoc "Enable nomad");

      server = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Whether the nomad agent should run as a server.
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
    services.nomad = mkMerge [
      {
        enable = true;
        package = pkgs.nomad_1_4;
        enableDocker = false;

        settings = {
          datacenter = cfg.datacenter;
        };
      }
      (mkIf cfg.server {
        # server specific options
        settings.server = {
          enabled = true;
          bootstrap_expect = cfg.bootstrapExpect;
        };
      })
    ];

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        4647 # RPC
        4648 # Serf WAN
      ] ++ (lib.optionals (cfg.webUi) [
        4646 # HTTP / web ui
      ]);

      allowedUDPPorts = [
        4648 # Serf WAN
      ];
    };
  };
}
