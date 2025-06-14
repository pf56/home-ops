{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.roles.nameserver;
in
{
  options = {
    roles.nameserver = {
      enable = mkEnableOption (mdDoc "Enable a nameserver");

      virtualIp = mkOption {
        type = types.str;
        default = "172.16.60.100";
        description = mdDoc ''
          The virtual ip to attach to the nameserver.
        '';
      };

      localAS = mkOption {
        type = types.str;
        default = null;
        description = mdDoc ''
          The local AS to use for the BGP session.
        '';
      };

      remoteAS = mkOption {
        type = types.str;
        default = null;
        description = mdDoc ''
          The remote AS to use for the BGP session.
        '';
      };

      remotePeer = mkOption {
        type = types.str;
        default = null;
        description = mdDoc ''
          The remote peer to initiate the BGP session with.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    networking.interfaces."lo" = {
      name = "lo";
      ipv4 = {
        addresses = [
          {
            address = cfg.virtualIp;
            prefixLength = 32;
          }
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [
      53
      179
    ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    services.frr = {
      bgpd.enable = true;

      config = ''
        route-map ALLOW-ALL permit 100

        router bgp ${cfg.localAS}
          neighbor ${cfg.remotePeer} remote-as ${cfg.remoteAS}
          address-family ipv4 unicast
            neighbor ${cfg.remotePeer} activate
            neighbor ${cfg.remotePeer} route-map ALLOW-ALL out
            network ${cfg.virtualIp}/32
          exit-address-family
      '';
    };

    services.routedns = {
      enable = true;
      settings = {
        resolvers.cloudflare-dot = {
          address = "1.1.1.1:853";
          protocol = "dot";
        };

        resolvers.google-udp = {
          address = "8.8.8.8:53";
          protocol = "udp";
        };

        resolvers.internal-udp = {
          address = "127.0.0.1:5300";
          protocol = "udp";
        };

        groups.upstream = {
          resolvers = [
            "cloudflare-dot"
            "google-udp"
          ];
          type = "fail-rotate";
        };

        routers.router1 = {
          routes = [
            {
              name = "(^|\.)internal\.paulfriedrich\.me\.$";
              resolver = "internal-udp";
            }
            {
              name = "\.10\.in-addr\.arpa\.$";
              resolver = "internal-udp";
            }
            {
              resolver = "upstream";
            }
          ];
        };

        groups.main-cached = {
          type = "cache";
          resolvers = [ "router1" ];
        };

        listeners.local-udp = {
          address = ":53";
          protocol = "udp";
          resolver = "main-cached";
        };

        listeners.local-tcp = {
          address = ":53";
          protocol = "tcp";
          resolver = "main-cached";
        };
      };
    };

    services.knot = {
      enable = true;

      settings = {
        server = {
          listen = [
            "127.0.0.1@5300"
            "::1@5300"
          ];
        };

        log = [
          {
            target = "syslog";
            any = "info";
          }
        ];

        template = [
          {
            id = "default";
            semantic-checks = "on";
          }
        ];

        zone = [
          {
            domain = "vultr.internal.paulfriedrich.me";
            file = "${./vultr.internal.paulfriedrich.me.zone}";
          }
          {
            domain = "internal.paulfriedrich.me";
            file = "${./internal.paulfriedrich.me.zone}";
          }
          {
            domain = "15.0.10.in-addr.arpa";
            file = "${./15.0.10.in-addr.arpa.zone}";
          }
          {
            domain = "20.0.10.in-addr.arpa";
            file = "${./20.0.10.in-addr.arpa.zone}";
          }
          {
            domain = "40.0.10.in-addr.arpa";
            file = "${./40.0.10.in-addr.arpa.zone}";
          }
          {
            domain = "60.0.10.in-addr.arpa";
            file = "${./60.0.10.in-addr.arpa.zone}";
          }
          {
            domain = "100.10.in-addr.arpa";
            file = "${./100.10.in-addr.arpa.zone}";
          }
        ];
      };
    };
  };
}
