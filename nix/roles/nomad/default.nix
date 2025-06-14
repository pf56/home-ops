{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.roles.nomad;
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

      docker = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Whether Docker should be enabled.
        '';
      };

      supplementaryGroups = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = mdDoc ''
          Additional groups to add to the systemd unit.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.nomad = mkMerge [
      {
        enable = true;
        package = pkgs.nomad_1_4;
        dropPrivileges = false;
        enableDocker = cfg.docker;

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
      (mkIf (!cfg.server) {
        # client specific options
        settings.client = {
          enabled = true;
          cni_path = "${pkgs.cni-plugins}/bin";
        };
      })
      (mkIf (!cfg.server && cfg.docker) {
        extraSettingsPaths = [ "/etc/nomad-docker.hcl" ];
      })
    ];

    environment.etc."/nomad-docker.hcl" = {
      source = ./nomad-docker.hcl;
    };

    systemd.services.nomad =
      let
        supplementaryGroups = cfg.supplementaryGroups ++ (lib.optionals (cfg.docker)) [ "docker" ];
      in
      mkIf (cfg.supplementaryGroups != null) {
        serviceConfig.SupplementaryGroups = pkgs.lib.mkForce (
          pkgs.lib.concatStringsSep " " supplementaryGroups
        );
      };

    networking.firewall = {
      enable = true;
      allowedTCPPorts =
        [
          4647 # RPC
          4648 # Serf WAN
        ]
        ++ (lib.optionals (cfg.webUi) [
          4646 # HTTP / web ui
        ]);

      allowedTCPPortRanges = [
        {
          # sidecar proxies
          from = 20000;
          to = 32000;
        }
      ];

      allowedUDPPorts = [
        4648 # Serf WAN
      ];
    };
  };
}
