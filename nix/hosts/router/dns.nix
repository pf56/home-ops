{ pkgs, lib, routerConfig, ... }:

let
  inherit (routerConfig) vlans wellKnowns;
in
{
  networking = {
    nameservers = [ wellKnowns.dns ];
  };

  services.resolved = {
    enable = true;
    domains = [ "internal.paulfriedrich.me" "~." ];
    fallbackDns = [ ];

    extraConfig = ''
      DNSStubListenerExtra=${vlans.mgmt.gateway}
      DNSStubListenerExtra=${vlans.office.gateway}
      DNSStubListenerExtra=${vlans.server.gateway}
    '';
  };
}
