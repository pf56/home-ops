{
  pkgs,
  lib,
  routerConfig,
  ...
}:

let
  inherit (routerConfig) interfaces vlans;
in
{
  networking = {
    useNetworkd = true;
    usePredictableInterfaceNames = true;
  };

  systemd.network = {
    wait-online.anyInterface = true;

    netdevs = {
      "10-dslite" = {
        netdevConfig = {
          Kind = "ip6tnl";
          Name = interfaces.dslite.name;
        };

        tunnelConfig = {
          Mode = "ipip6";
          Local = "dhcp6";
          Remote = "2a01:41e3:ffff:cafe:face::4"; # aftr.fra.purtel.com
        };
      };

      "20-br-lan" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-lan";
        };
      };

      "20-vlan7" = {
        netdevConfig = {
          Kind = "vlan";
          Name = vlans.isp.name;
        };

        vlanConfig.Id = vlans.isp.id;
      };

      "20-vlan10" = {
        netdevConfig = {
          Kind = "vlan";
          Name = vlans.mgmt.name;
        };

        vlanConfig.Id = vlans.mgmt.id;
      };

      "20-vlan20" = {
        netdevConfig = {
          Kind = "vlan";
          Name = vlans.office.name;
        };

        vlanConfig.Id = vlans.office.id;
      };

      "20-vlan40" = {
        netdevConfig = {
          Kind = "vlan";
          Name = vlans.iot.name;
        };

        vlanConfig.Id = vlans.iot.id;
      };

      "20-vlan60" = {
        netdevConfig = {
          Kind = "vlan";
          Name = vlans.server.name;
        };

        vlanConfig.Id = vlans.server.id;
      };
    };

    networks = {
      "30-wan" = {
        matchConfig.Name = interfaces.wan.name;

        networkConfig = {
          Description = "WAN";
          DHCP = true;

          IPv6PrivacyExtensions = false;
          IPv6AcceptRA = true;
        };

        dhcpV4Config = {
          UseHostname = false;
          SendHostname = false;
          UseDNS = false;
          UseNTP = false;
        };

        vlan = [
          vlans.isp.name
        ];
      };

      "30-vlan7" = {
        matchConfig.Name = vlans.isp.name;

        networkConfig = {
          Description = "ISP";
        };
      };

      "30-ppp0" = {
        matchConfig.Name = interfaces.ppp.name;

        networkConfig = {
          DHCP = true;
          KeepConfiguration = "static";

          IPv6Forwarding = true;
          IPv6AcceptRA = true;
          DHCPPrefixDelegation = true;

          Tunnel = interfaces.dslite.name;
        };

        routes = [
          { Destination = "::/0"; }
        ];

        dhcpV6Config = {
          WithoutRA = "solicit";
          RequestOptions = "64"; # AFTR-Name
          PrefixDelegationHint = "::/56";

          UseDNS = false;
          UseNTP = false;
          UseHostname = false;
          UseDomains = false;
        };

        ipv6AcceptRAConfig = {
          DHCPv6Client = "always";
        };
      };

      "30-dslite" = {
        matchConfig.Name = interfaces.dslite.name;

        networkConfig = {
          IPv4Forwarding = true;
        };

        routes = [
          { Destination = "0.0.0.0/0"; }
        ];
      };

      "30-lan1" = {
        matchConfig.Name = interfaces.lan1.name;
        linkConfig.RequiredForOnline = "enslaved";
        networkConfig = {
          Bridge = "br-lan";
          ConfigureWithoutCarrier = true;
        };
      };

      "30-lan2" = {
        matchConfig.Name = interfaces.lan2.name;
        linkConfig.RequiredForOnline = "enslaved";
        networkConfig = {
          Bridge = "br-lan";
          ConfigureWithoutCarrier = true;
        };
      };

      "30-lan3" = {
        matchConfig.Name = interfaces.lan3.name;
        linkConfig.RequiredForOnline = "enslaved";
        networkConfig = {
          Bridge = "br-lan";
          ConfigureWithoutCarrier = true;
        };
      };

      "40-br-lan" = {
        matchConfig.Name = "br-lan";
        linkConfig.RequiredForOnline = "no-carrier";

        networkConfig = {
          LinkLocalAddressing = false;
          ConfigureWithoutCarrier = true;
        };

        vlan = [
          vlans.mgmt.name
          vlans.office.name
          vlans.iot.name
          vlans.server.name
        ];
      };

      "50-vlan10" = {
        matchConfig.Name = vlans.mgmt.name;

        networkConfig = {
          Description = "MGMT";
          DHCP = false;
          IPv6AcceptRA = false;
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };

        address = [
          "${vlans.mgmt.gateway}/${vlans.mgmt.prefixLength}"
        ];
      };

      "50-vlan20" = {
        matchConfig.Name = vlans.office.name;

        networkConfig = {
          Description = "OFFICE";
          DHCP = false;
          IPv4Forwarding = true;
          IPv6Forwarding = true;
          IPv6AcceptRA = false;
          IPv6SendRA = true;
          DHCPPrefixDelegation = true;
        };

        address = [
          "${vlans.office.gateway}/${vlans.office.prefixLength}"
        ];
      };

      "50-vlan40" = {
        matchConfig.Name = vlans.iot.name;

        networkConfig = {
          Description = "IOT";
          DHCP = false;
          IPv6AcceptRA = false;
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };

        address = [
          "${vlans.iot.gateway}/${vlans.iot.prefixLength}"
        ];
      };

      "50-vlan60" = {
        matchConfig.Name = vlans.server.name;

        networkConfig = {
          Description = "SERVER";
          DHCP = false;
          IPv4Forwarding = true;
          IPv6Forwarding = true;
          IPv6AcceptRA = false;
          IPv6SendRA = true;
          DHCPPrefixDelegation = true;
        };

        address = [
          "${vlans.server.gateway}/${vlans.server.prefixLength}"
        ];
      };
    };
  };
}
