{ pkgs, lib, routerConfig, ... }:

let
  inherit (routerConfig) vlans;
in
{
  networking = {
    useDHCP = false;
  };

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
            vlans.server.name
          ];
        };

        lease-database = {
          name = "/var/lib/kea/dhcp4.leases";
          persist = true;
          type = "memfile";
        };

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
                # HL2250DN
                hw-address = "00:1b:a9:d1:0a:eb";
                ip-address = "10.0.20.2";
              }
              {
                # TrueNAS
                hw-address = "50:eb:f6:b6:7f:f7";
                ip-address = "10.0.20.3";
              }
              {
                # Prua Mk4
                hw-address = "10:9c:70:2c:d2:40";
                ip-address = "10.0.20.4";
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
            ];
          }
        ];
      };
    };
  };
}