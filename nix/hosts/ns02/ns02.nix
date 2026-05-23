{ den, ... }:
{
  den.aspects.ns02 = {
    includes = [
      den.aspects.bootable
      den.aspects.server-base
      den.aspects.nameserver
    ];

    nixos =
      { pkgs, config, ... }:
      {
        imports = [
          ./_hardware-configuration.nix
        ];

        networking.hostName = "ns02";

        roles.nameserver = {
          enable = true;
          virtualIp = "172.16.60.100";
          localAS = "4200060018";
          remoteAS = "4200060001";
          remotePeer = "10.0.60.1";
        };

        system.stateVersion = "23.05";
      };
  };
}
