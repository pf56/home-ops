{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../base/configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ns01";
  roles.vmwareguest.enable = true;

  lollypops.deployment.ssh.host = lib.mkForce "10.0.60.17";

  networking.interfaces."lo" = {
    name = "lo";
    ipv4 = {
      addresses = [
        {
          address = "172.16.60.100";
          prefixLength = 32;
        }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 179 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.frr = {
    bgp = {
      enable = true;

      config = ''
        route-map ALLOW-ALL permit 100

        router bgp 4200060017
          neighbor 10.0.60.1 remote-as 4200060001
          address-family ipv4 unicast
            neighbor 10.0.60.1 activate
            neighbor 10.0.60.1 route-map ALLOW-ALL out
            network 172.16.60.100/32
          exit-address-family
      '';
    };
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
        resolvers = [ "cloudflare-dot" "google-udp" ];
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

    extraConfig = ''
      server:
        listen: 127.0.0.1@5300
        listen: ::1@5300

      log:
        - target: syslog
          any: info

      template:
        - id: default
          semantic-checks: on
          
      zone:
        - domain: internal.paulfriedrich.me
          file: "${./internal.paulfriedrich.me.zone}"

      zone:
        - domain: 15.0.10.in-addr.arpa
          file: "${./15.0.10.in-addr.arpa.zone}"

      zone:
        - domain: 20.0.10.in-addr.arpa
          file: "${./20.0.10.in-addr.arpa.zone}"

      zone:
        - domain: 60.0.10.in-addr.arpa
          file: "${./60.0.10.in-addr.arpa.zone}"
    '';
  };

  system.stateVersion = "23.05";
}
