{
  pkgs,
  lib,
  routerConfig,
  ...
}:

let
  inherit (routerConfig) vlans wellKnowns;
in
{
  networking = {
    nameservers = [
      wellKnowns.dns
      "9.9.9.9"
    ];
  };

  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        Domains = [
          "internal.paulfriedrich.me"
          "~."
        ];

        DNSStubListenerExtra = [
          vlans.mgmt.gateway
          vlans.office.gateway
          vlans.iot.gateway
          vlans.server.gateway
        ];
      };
    };
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
