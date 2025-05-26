{ pkgs, lib, routerConfig, ... }:

let
  inherit (routerConfig) vlans wellKnowns;
in
{
  networking = {
    nameservers = [ wellKnowns.dns "9.9.9.9" ];
  };

  services.resolved = {
    enable = true;
    domains = [ "internal.paulfriedrich.me" "~." ];

    extraConfig = ''
      DNSStubListenerExtra=${vlans.mgmt.gateway}
      DNSStubListenerExtra=${vlans.office.gateway}
      DNSStubListenerExtra=${vlans.iot.gateway}
      DNSStubListenerExtra=${vlans.server.gateway}
    '';
  };

  services.avahi = {
    enable = true;
    reflector = true;
    allowInterfaces = [
      vlans.office.name
      vlans.iot.name
      vlans.server.name
    ];
  };
}
