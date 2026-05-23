{
  pkgs,
  lib,
  routerConfig,
  config,
  ...
}:

let
  inherit (routerConfig) vlans wellKnowns;
in
{
  roles.nameserver = {
    enable = true;
    enableBgpPeering = false;
  };

  networking.nameservers = [
    "127.0.0.1:${toString config.roles.nameserver.port}"
    # wellKnowns.dns
    # "9.9.9.9"
  ];

  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        Domains = [
          "internal.paulfriedrich.me"
          "~."
        ];

        DNSStubListener = false;
        DNSStubListenerExtra = [
          # vlans.mgmt.gateway
          # vlans.office.gateway
          # vlans.iot.gateway
          # vlans.server.gateway
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
