{ config, pkgs, lib, ... }:

let
  interfaces = {
    wan = {
      name = "enp1s0";
    };

    lan1 = {
      name = "enp2s0";
    };

    lan2 = {
      name = "enp3s0";
    };

    lan3 = {
      name = "enp4s0";
    };
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ../../base/configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel = {
      sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;
        "net.ipv6.conf.${interfaces.wan.name}.accept_ra" = 2; # https://github.com/tailscale/tailscale/issues/6826
      };
    };
  };

  environment.systemPackages = with pkgs; [
    dig
    tcpdump
  ];

  networking = {
    hostName = "router";
    useNetworkd = true;
    useDHCP = false;
    usePredictableInterfaceNames = true;

    nat.enable = false;
    firewall.enable = false;

    nameservers = [ "172.16.60.100" ];

    nftables = {
      enable = true;

      checkRuleset = false;
      ruleset = ''
        table inet filter {
          define TALOS_WORKERS = {
            10.0.60.9,
            10.0.60.10,
            10.0.60.13
          }

          define TALOS_CONTROLPLANE = {
            10.0.60.7,
            10.0.60.11,
            10.0.60.12
          }

          define TALOS_NODES = {
           $TALOS_WORKERS,
           $TALOS_CONTROLPLANE
          }

          define NAMESERVERS = {
            10.0.60.18,
            172.16.60.100
          }

          flowtable f {
            hook ingress priority 0;
            devices = { ${interfaces.wan.name}, ${interfaces.lan1.name}, ${interfaces.lan2.name}, ${interfaces.lan3.name} }
            # flags offload
          }

          chain INPUT {
            type filter hook input priority filter; policy drop;

            # allow established/related, drop invalid
            ct state vmap { established : accept, related : accept, invalid : drop }

            # allow ICMP
            ip protocol icmp accept
            meta l4proto ipv6-icmp accept

            iif lo accept
            iifname ${interfaces.wan.name} jump WAN-LOCAL
            iifname vlan10 jump MGMT-LOCAL
            iifname vlan20 jump OFFICE-LOCAL
            iifname vlan60 jump SERVER-LOCAL
          }

          chain FORWARD {
            type filter hook forward priority filter; policy drop;

            ip protocol { tcp, udp } ct state { established } flow offload @f

            # allow established/related, drop invalid
            ct state vmap { established : accept, related : accept, invalid : drop }

            # allow ICMP
            ip protocol icmp accept
            meta l4proto ipv6-icmp accept

            oifname ${interfaces.wan.name} jump ZONE_WAN
            oifname vlan10 jump ZONE_MGMT
            oifname vlan20 jump ZONE_OFFICE
            oifname vlan60 jump ZONE_SERVER
          }

          chain OUTPUT {
            type filter hook output priority filter; policy drop;

            # allow established/related, drop invalid
            ct state vmap { established : accept, related : accept, invalid : drop }

            # allow ICMP
            ip protocol icmp accept
            meta l4proto ipv6-icmp accept

            oif lo accept
            oifname ${interfaces.wan.name} accept
            oifname vlan60 jump LOCAL-SERVER
          }

          chain ZONE_WAN {
            iifname vlan10 jump MGMT-WAN
            iifname vlan20 jump OFFICE-WAN
            iifname vlan60 jump SERVER-WAN
            counter drop
          }

          chain ZONE_MGMT {
            iifname vlan20 jump OFFICE-MGMT
            counter drop
          }

          chain ZONE_OFFICE {
            counter drop
          }

          chain ZONE_SERVER {
            iifname vlan20 jump OFFICE-SERVER
            counter drop
          }

          chain WAN-LOCAL {
            tcp dport 22 accept comment "Allow SSH"
            counter drop
          }

          chain LOCAL-SERVER {
            ip daddr $NAMESERVERS meta l4proto { tcp, udp } th dport 53 accept comment "Allow DNS"
            ip daddr $NAMESERVERS tcp dport 179 accept comment "Allow BGP with DNS"
            ip daddr $TALOS_WORKERS tcp dport 179 accept comment "Allow BGP with Talos"
            counter drop
          }

          chain OFFICE-WAN {
            accept
          }

          chain OFFICE-MGMT {
            ip daddr 10.0.10.2 tcp dport { 80, 443 } accept comment "Allow TrueNAS"
            counter drop
          }

          chain OFFICE-LOCAL {
            tcp dport 22 accept comment "Allow SSH"
            meta l4proto { tcp, udp } th dport 53 accept comment "Allow DNS"
            udp dport 67 udp sport 68 accept comment "Allow DHCP"
          }

          chain OFFICE-SERVER {
            tcp dport 22 accept comment "Allow SSH"
            ip daddr 10.0.60.8 accept comment "Allow Git"

            ip daddr 10.0.60.5 tcp dport 6443 accept comment "Allow Kubernetes API"
            ip daddr $TALOS_NODES tcp dport 50000 accept comment "Allow Talos control plane"
            ip daddr 172.16.61.0/24 tcp dport { 80, 443 } accept comment "Allow Cilium LB"
          }

          chain MGMT-WAN {
            accept
          }

          chain MGMT-LOCAL {
            tcp dport 22 accept comment "Allow SSH"
            meta l4proto { tcp, udp } th dport 53 accept comment "Allow DNS"
            udp dport 67 udp sport 68 accept comment "Allow DHCP"
          }

          chain SERVER-WAN {
            accept
          }

          chain SERVER-LOCAL {
            tcp dport 22 accept comment "Allow SSH"
            meta l4proto { tcp, udp } th dport 53 accept comment "Allow DNS"
            udp dport 67 udp sport 68 accept comment "Allow DHCP"
            tcp dport 179 accept comment "Allow BGP"
          }
        }

        table ip nat {
          chain POSTROUTING {
            type nat hook postrouting priority 100; policy accept;
            oifname ${interfaces.wan.name} masquerade
          }
        }
      '';
    };
  };

  systemd.network = {
    wait-online.anyInterface = true;

    netdevs = {
      "20-br-lan" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-lan";
        };
      };

      "20-vlan10" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan10";
        };

        vlanConfig.Id = 10;
      };

      "20-vlan20" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan20";
        };

        vlanConfig.Id = 20;
      };

      "20-vlan60" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan60";
        };

        vlanConfig.Id = 60;
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
          "vlan10"
          "vlan20"
          "vlan60"
        ];
      };

      "50-vlan10" = {
        matchConfig.Name = "vlan10";

        networkConfig = {
          Description = "MGMT";
          DHCP = false;
          IPv6AcceptRA = false;
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };

        address = [
          "10.0.10.1/24"
        ];
      };

      "50-vlan20" = {
        matchConfig.Name = "vlan20";

        networkConfig = {
          Description = "OFFICE";
          DHCP = false;
          IPv6AcceptRA = false;
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };

        address = [
          "10.0.20.1/24"
        ];
      };

      "50-vlan60" = {
        matchConfig.Name = "vlan60";

        networkConfig = {
          Description = "SERVER";
          DHCP = false;
          IPv6AcceptRA = false;
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };

        address = [
          "10.0.60.1/24"
        ];
      };
    };
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
            "vlan10"
            "vlan20"
            "vlan60"
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
            subnet = "10.0.10.0/24";

            pools = [
              {
                pool = "10.0.10.100 - 10.0.10.199";
              }
            ];

            option-data = [
              {
                name = "routers";
                data = "10.0.10.1";
              }
              {
                name = "domain-name-servers";
                data = "10.0.10.1";
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
            subnet = "10.0.20.0/24";
            pools = [
              {
                pool = "10.0.20.100 - 10.0.20.199";
              }
            ];

            option-data = [
              {
                name = "routers";
                data = "10.0.20.1";
              }
              {
                name = "domain-name-servers";
                data = "10.0.20.1";
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
            subnet = "10.0.60.0/24";
            pools = [
              {
                pool = "10.0.60.100 - 10.0.60.199";
              }
            ];

            option-data = [
              {
                name = "routers";
                data = "10.0.60.1";
              }
              {
                name = "domain-name-servers";
                data = "10.0.60.1";
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

  services.resolved = {
    enable = true;
    domains = [ "internal.paulfriedrich.me" "~." ];
    fallbackDns = [ ];

    extraConfig = ''
      DNSStubListenerExtra=10.0.10.1
      DNSStubListenerExtra=10.0.20.1
      DNSStubListenerExtra=10.0.60.1
    '';
  };

  services.frr = {
    bgpd.enable = true;

    config = ''
      router bgp 4200060001
       bgp router-id 10.0.60.1
       no bgp ebgp-requires-policy
       no bgp default ipv4-unicast
       no bgp network import-check
       !
       neighbor 10.0.60.9 remote-as 4200060005
       neighbor 10.0.60.9 interface vlan60
       neighbor 10.0.60.9 update-source vlan60
       !
       neighbor 10.0.60.10 remote-as 4200060005
       neighbor 10.0.60.10 interface vlan60
       neighbor 10.0.60.10 update-source vlan60
       !
       neighbor 10.0.60.13 remote-as 4200060005
       neighbor 10.0.60.13 interface vlan60
       neighbor 10.0.60.13 update-source vlan60
       !
       neighbor 10.0.60.18 remote-as 4200060018
       neighbor 10.0.60.18 interface vlan60
       neighbor 10.0.60.18 update-source vlan60
       !
       address-family ipv4 unicast
        neighbor 10.0.60.9 activate
        neighbor 10.0.60.9 soft-reconfiguration inbound
        !
        neighbor 10.0.60.10 activate
        neighbor 10.0.60.10 soft-reconfiguration inbound
        !
        neighbor 10.0.60.13 activate
        neighbor 10.0.60.13 soft-reconfiguration inbound
        !
        neighbor 10.0.60.18 activate
        neighbor 10.0.60.18 soft-reconfiguration inbound
       exit address-family
      exit
    '';
  };

  sops.secrets = { };

  lollypops.deployment = {
    local-evaluation = false;
    ssh.host = lib.mkForce "192.168.178.37";
  };

  system.stateVersion = "24.11";
}
