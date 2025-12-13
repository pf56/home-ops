{
  pkgs,
  lib,
  routerConfig,
  ...
}:

let
  inherit (routerConfig) vlans;

  dhcpV4ControlSocket = "/run/kea/dhcpv4";

  getLeases = pkgs.writeShellScriptBin "get-dhcp-leases" ''
    set -euo pipefail

    GET_LEASES=$(cat <<-END
      {
        "command": "lease4-get-all"
      }
    END
    )

    LEASES=$(echo $GET_LEASES | ${pkgs.socat}/bin/socat UNIX-CONNECT:${dhcpV4ControlSocket} -)

    echo $LEASES | ${pkgs.jq}/bin/jq -r '["HOST", "IP", "MAC"], ["----", "----", "----"], (.arguments.leases.[] | [.hostname, ."ip-address", ."hw-address"]) | @tsv' - | column -ts $'\t'
  '';
in
{
  networking = {
    useDHCP = false;
  };

  environment.systemPackages = [ getLeases ];

  services.kea = {
    dhcp4 = {
      enable = true;
      settings = {
        rebind-timer = 2000;
        renew-timer = 1000;
        valid-lifetime = 4000;

        interfaces-config = {
          interfaces = [
            vlans.mgmt.name
            vlans.office.name
            vlans.iot.name
            vlans.server.name
          ];
        };

        lease-database = {
          name = "/var/lib/kea/dhcp4.leases";
          persist = true;
          type = "memfile";
        };

        control-socket = {
          socket-type = "unix";
          socket-name = dhcpV4ControlSocket;
        };

        hooks-libraries = [
          {
            library = "${pkgs.kea}/lib/kea/hooks/libdhcp_lease_cmds.so";
          }
        ];

        option-data = [
          {
            name = "domain-name";
            data = "internal.paulfriedrich.me";
          }
        ];

        subnet4 = [
          {
            id = 10;
            subnet = vlans.mgmt.subnet;

            pools = [
              {
                pool = "10.0.10.100 - 10.0.10.199";
              }
            ];

            option-data = [
              {
                name = "routers";
                data = vlans.mgmt.gateway;
              }
              {
                name = "time-servers";
                data = vlans.mgmt.gateway;
              }
              {
                name = "domain-name-servers";
                data = vlans.mgmt.gateway;
              }
              {
                code = 138; # omada-controller
                data = "172.16.61.3";
              }
            ];

            reservations = [
              {
                # TrueNAS
                hw-address = "50:eb:f6:b6:7f:f8";
                ip-address = "10.0.10.2";
              }
              {
                # MikroTik CSS610-8G-2S+
                hw-address = "2c:c8:1b:40:32:3d";
                ip-address = "10.0.10.3";
              }
            ];
          }
          {
            id = 20;
            subnet = vlans.office.subnet;
            pools = [
              {
                pool = "10.0.20.100 - 10.0.20.199";
              }
            ];

            option-data = [
              {
                name = "routers";
                data = vlans.office.gateway;
              }
              {
                name = "time-servers";
                data = vlans.office.gateway;
              }
              {
                name = "domain-name-servers";
                data = vlans.office.gateway;
              }
            ];

            reservations = [
              {
                # printer
                hw-address = "e8:65:38:e3:82:76";
                ip-address = "10.0.20.2";
              }
              {
                # TrueNAS
                hw-address = "50:eb:f6:b6:7f:f7";
                ip-address = "10.0.20.3";
              }
              {
                # Prusa Mk4
                hw-address = "10:9c:70:2c:d2:40";
                ip-address = "10.0.20.4";
              }
            ];
          }
          {
            id = 40;
            subnet = vlans.iot.subnet;
            pools = [
              {
                pool = "10.0.40.100 - 10.0.40.199";
              }
            ];

            option-data = [
              {
                name = "routers";
                data = vlans.iot.gateway;
              }
              {
                name = "time-servers";
                data = vlans.iot.gateway;
              }
              {
                name = "domain-name-servers";
                data = vlans.iot.gateway;
              }
            ];

            reservations = [
              {
                # TrueNAS
                hw-address = "ff:ff:ff:ff:ff:ff";
                ip-address = "10.0.40.2";
              }
              {
                # Home Assistant
                hw-address = "00:a0:98:29:f9:b4";
                ip-address = "10.0.40.3";
              }
              {
                # Bosch Smart Home Controller
                hw-address = "64:da:a0:40:85:50";
                ip-address = "10.0.40.4";
              }
              {
                # Zenfone 8
                hw-address = "7c:10:c9:0b:e9:65";
                ip-address = "10.0.40.5";
              }
              {
                # LR4
                hw-address = "c8:f0:9e:76:9f:38";
                ip-address = "10.0.40.6";
              }
              {
                # Roomba
                hw-address = "4c:b9:ea:07:3f:de";
                ip-address = "10.0.40.7";
              }
            ];
          }
          {
            id = 60;
            subnet = vlans.server.subnet;
            pools = [
              {
                pool = "10.0.60.100 - 10.0.60.199";
              }
            ];

            option-data = [
              {
                name = "routers";
                data = vlans.server.gateway;
              }
              {
                name = "time-servers";
                data = vlans.server.gateway;
              }
              {
                name = "domain-name-servers";
                data = vlans.server.gateway;
              }
            ];

            reservations = [
              {
                # TrueNAS
                hw-address = "50:eb:f6:b6:7f:f8";
                ip-address = "10.0.60.3";
              }
              {
                # Talos control plane
                hw-address = "ff:ff:ff:ff:ff:ff";
                ip-address = "10.0.60.5";
              }
              {
                # Talos control plane 01
                hw-address = "00:a0:98:24:ce:69";
                ip-address = "10.0.60.7";
              }
              {
                # git
                hw-address = "00:a0:98:72:7b:98";
                ip-address = "10.0.60.8";
              }
              {
                # Talos worker 01
                hw-address = "00:a0:98:31:e5:ea";
                ip-address = "10.0.60.9";
              }
              {
                # Talos worker 02
                hw-address = "00:a0:98:16:48:10";
                ip-address = "10.0.60.10";
              }
              {
                # Talos control plane 02
                hw-address = "00:a0:98:4f:1c:57";
                ip-address = "10.0.60.11";
              }
              {
                # Talos control plane 03
                hw-address = "00:a0:98:5f:a6:e7";
                ip-address = "10.0.60.12";
              }
              {
                # Talos worker 03
                hw-address = "00:a0:98:31:dd:4a";
                ip-address = "10.0.60.13";
              }
              {
                # ns02
                hw-address = "00:a0:98:11:85:19";
                ip-address = "10.0.60.18";
              }
              {
                # monitoring
                hw-address = "00:a0:98:6b:82:02";
                ip-address = "10.0.60.19";
              }
            ];
          }
        ];
      };
    };
  };

  services.prometheus.exporters.kea = {
    enable = true;
    listenAddress = vlans.server.gateway;
    targets = [
      dhcpV4ControlSocket
    ];
  };
}
