{
  config,
  lib,
  pkgs,
  routerConfig,
  ...
}:

let
  inherit (routerConfig) interfaces vlans wellKnowns;
in
{
  networking = {
    nat.enable = false;
    firewall.enable = false;

    nftables = {
      enable = true;

      # doesn't work with flowtables
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
            ${wellKnowns.dns}
          }

          flowtable f {
            hook ingress priority 0;
            devices = { ${interfaces.wan.name}, ${interfaces.lan1.name}, ${interfaces.lan2.name}, ${interfaces.lan3.name} }
            # flags offload
          }

          chain INPUT {
            type filter hook input priority filter; policy drop;

            # clamp mss
            tcp flags syn tcp option maxseg size set 1404

            # allow established/related, drop invalid
            ct state vmap { established : accept, related : accept, invalid : drop }

            # allow ICMP
            ip protocol icmp accept
            meta l4proto ipv6-icmp accept

            # Allow mDNS
            iifname { ${vlans.office.name}, ${vlans.iot.name}, ${vlans.server.name} } ip daddr 224.0.0.251 udp dport 5353 accept

            iif lo accept
            iifname ${interfaces.wan.name} jump WAN-LOCAL
            iifname ${interfaces.ppp.name} jump WAN-LOCAL
            iifname ${interfaces.dslite.name} jump WAN-LOCAL
            iifname ${interfaces.tailscale.name} jump TAILSCALE-LOCAL
            iifname ${vlans.mgmt.name} jump MGMT-LOCAL
            iifname ${vlans.office.name} jump OFFICE-LOCAL
            iifname ${vlans.iot.name} jump IOT-LOCAL
            iifname ${vlans.server.name} jump SERVER-LOCAL

            log prefix "nftables-drop input: " drop
          }

          chain FORWARD {
            type filter hook forward priority filter; policy drop;

            # clamp mss
            tcp flags syn tcp option maxseg size set 1404

            ip protocol { tcp, udp } ct state { established } flow offload @f

            # allow established/related, drop invalid
            ct state vmap { established : accept, related : accept, invalid : drop }

            # allow ICMP
            ip protocol icmp accept
            meta l4proto ipv6-icmp accept

            oifname ${interfaces.wan.name} jump ZONE_WAN
            oifname ${interfaces.ppp.name} jump ZONE_WAN
            oifname ${interfaces.dslite.name} jump ZONE_WAN
            oifname ${vlans.mgmt.name} jump ZONE_MGMT
            oifname ${vlans.office.name} jump ZONE_OFFICE
            oifname ${vlans.iot.name} jump ZONE_IOT
            oifname ${vlans.server.name} jump ZONE_SERVER

            log prefix "nftables-drop forward: " drop
          }

          chain OUTPUT {
            type filter hook output priority filter; policy drop;

            # allow established/related, drop invalid
            ct state vmap { established : accept, related : accept, invalid : drop }

            # allow ICMP
            ip protocol icmp accept
            meta l4proto ipv6-icmp accept

            # Allow mDNS
            oifname { ${vlans.office.name}, ${vlans.iot.name}, ${vlans.server.name} } ip daddr 224.0.0.251 udp dport 5353 accept

            oif lo accept
            oifname ${interfaces.wan.name} accept
            oifname ${interfaces.ppp.name} accept
            oifname ${interfaces.dslite.name} accept
            oifname ${vlans.server.name} jump LOCAL-SERVER

            log prefix "nftables-drop output: " drop
          }

          chain ZONE_WAN {
            iifname ${vlans.mgmt.name} jump MGMT-WAN
            iifname ${vlans.office.name} jump OFFICE-WAN
            iifname ${vlans.iot.name} jump IOT-WAN
            iifname ${vlans.server.name} jump SERVER-WAN
            counter drop
          }

          chain ZONE_MGMT {
            iifname ${vlans.mgmt.name} accept comment "Loopback"
            iifname ${vlans.office.name} jump OFFICE-MGMT
            iifname ${vlans.server.name} jump SERVER-MGMT
            counter drop
          }

          chain ZONE_OFFICE {
            iifname ${vlans.office.name} accept comment "Loopback"
            counter drop
          }

          chain ZONE_IOT {
            iifname ${interfaces.tailscale.name} jump TAILSCALE-IOT
            iifname ${vlans.office.name} jump OFFICE-IOT
            iifname ${vlans.iot.name} accept comment "Loopback"
            counter drop
          }
          
          chain ZONE_SERVER {
            iifname ${interfaces.tailscale.name} jump TAILSCALE-SERVER
            iifname ${vlans.mgmt.name} jump MGMT-SERVER
            iifname ${vlans.office.name} jump OFFICE-SERVER
            iifname ${vlans.iot.name} jump IOT-SERVER
            iifname ${vlans.server.name} accept comment "Loopback"
            counter drop
          }

          chain WAN-LOCAL {
            udp sport 547 udp dport 546 accept comment "Allow DHCPv6"
            counter drop
          }

          chain TAILSCALE-LOCAL {
            counter drop
          }

          chain TAILSCALE-SERVER {
            ip daddr $NAMESERVERS meta l4proto { tcp, udp } th dport 53 accept comment "Allow DNS"
            ip daddr 172.16.61.0/24 tcp dport { 80, 443 } accept comment "Allow Cilium LB"
            ip daddr 10.0.60.8 accept comment "Allow Git"
            ip daddr 10.0.60.15 accept comment "Allow Auth"
            counter drop
          }

          chain TAILSCALE-IOT {
            ip daddr 10.0.40.3 tcp dport { 443 } accept comment "Allow Home Assistant"
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
            ip daddr 10.0.10.3 tcp dport { 80, 443 } accept comment "Allow MikroTik"
            counter drop
          }

          chain OFFICE-LOCAL {
            tcp dport 22 accept comment "Allow SSH"
            meta l4proto { tcp, udp } th dport 53 accept comment "Allow DNS"
            udp dport 67 udp sport 68 accept comment "Allow DHCP"
            udp dport 123 accept comment "Allow NTP"
          }

          chain OFFICE-SERVER {
            tcp dport 22 accept comment "Allow SSH"
            ip daddr 10.0.60.8 accept comment "Allow Git"

            ip daddr 10.0.60.5 tcp dport 6443 accept comment "Allow Kubernetes API"
            ip daddr $TALOS_NODES tcp dport 50000 accept comment "Allow Talos control plane"
            ip daddr 172.16.61.0/24 tcp dport { 80, 443 } accept comment "Allow Cilium LB"
          }

          chain OFFICE-IOT {
            ip daddr 10.0.40.3 tcp dport { 4357, 443 } accept comment "Allow Home Assistant"
            ip daddr 10.0.40.4 tcp dport { 8000, 8443, 8444, 8445, 8446 } accept comment "Allow Bosch SHC"
          }

          chain MGMT-WAN {
            accept
          }

          chain MGMT-LOCAL {
            tcp dport 22 accept comment "Allow SSH"
            meta l4proto { tcp, udp } th dport 53 accept comment "Allow DNS"
            udp dport 67 udp sport 68 accept comment "Allow DHCP"
            udp dport 123 accept comment "Allow NTP"
          }

          chain MGMT-SERVER {
            ip daddr 172.16.61.3 meta l4proto { tcp, udp } accept comment "Allow Omada"
          }

          chain SERVER-WAN {
            accept
          }

          chain SERVER-LOCAL {
            tcp dport 22 accept comment "Allow SSH"
            meta l4proto { tcp, udp } th dport 53 accept comment "Allow DNS"
            udp dport 67 udp sport 68 accept comment "Allow DHCP"
            udp dport 123 accept comment "Allow NTP"
            tcp dport 179 accept comment "Allow BGP"
          }

          chain SERVER-MGMT {
            ip daddr 10.0.10.2 tcp dport { 80, 443 } accept comment "Allow TrueNAS API"
          }
          
          chain IOT-LOCAL {
            meta l4proto { tcp, udp } th dport 53 accept comment "Allow DNS"
            udp dport 67 udp sport 68 accept comment "Allow DHCP"
            udp dport 123 accept comment "Allow NTP"
          }

          chain IOT-WAN {
            ip saddr 10.0.40.3 accept comment "Allow Home Assistant"
            ip saddr 10.0.40.4 accept comment "Allow Bosch Smart Home Controller"
            ip saddr 10.0.40.5 accept comment "Allow Zenfone 8"
            ip saddr 10.0.40.6 accept comment "Allow LR4"
            ip saddr 10.0.40.7 accept comment "Allow Roomba"
            drop comment "Drop everything else"
          }

          chain IOT-SERVER {
            ip daddr 172.16.61.0/24 tcp dport { 80, 443 } accept comment "Allow Cilium LB"
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
}
