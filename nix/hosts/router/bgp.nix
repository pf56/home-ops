{
  pkgs,
  lib,
  routerConfig,
  ...
}:

let
  inherit (routerConfig) vlans;
in
{
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
       neighbor 10.0.60.9 interface ${vlans.server.name}
       neighbor 10.0.60.9 update-source ${vlans.server.name}
       !
       neighbor 10.0.60.10 remote-as 4200060005
       neighbor 10.0.60.10 interface ${vlans.server.name}
       neighbor 10.0.60.10 update-source ${vlans.server.name}
       !
       neighbor 10.0.60.13 remote-as 4200060005
       neighbor 10.0.60.13 interface ${vlans.server.name}
       neighbor 10.0.60.13 update-source ${vlans.server.name}
       !
       neighbor 10.0.60.18 remote-as 4200060018
       neighbor 10.0.60.18 interface ${vlans.server.name}
       neighbor 10.0.60.18 update-source ${vlans.server.name}
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
}
