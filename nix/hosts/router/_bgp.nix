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
       neighbor 10.0.60.23 remote-as 4200060005
       neighbor 10.0.60.23 interface ${vlans.server.name}
       neighbor 10.0.60.23 update-source ${vlans.server.name}
       !
       neighbor 10.0.60.24 remote-as 4200060005
       neighbor 10.0.60.24 interface ${vlans.server.name}
       neighbor 10.0.60.24 update-source ${vlans.server.name}
       !
       neighbor 10.0.60.25 remote-as 4200060005
       neighbor 10.0.60.25 interface ${vlans.server.name}
       neighbor 10.0.60.25 update-source ${vlans.server.name}
       !
       neighbor 10.0.60.18 remote-as 4200060018
       neighbor 10.0.60.18 interface ${vlans.server.name}
       neighbor 10.0.60.18 update-source ${vlans.server.name}
       !
       address-family ipv4 unicast
        neighbor 10.0.60.23 b activate
        neighbor 10.0.60.23 soft-reconfiguration inbound
        !
        neighbor 10.0.60.24 activate
        neighbor 10.0.60.24 soft-reconfiguration inbound
        !
        neighbor 10.0.60.25 activate
        neighbor 10.0.60.25 soft-reconfiguration inbound
        !
        neighbor 10.0.60.18 activate
        neighbor 10.0.60.18 soft-reconfiguration inbound
       exit address-family
      exit
    '';
  };
}
