{ lib, config, ... }:
{
  den.aspects.wireshark = {
    nixos =
      {
        pkgs,
        host,
        ...
      }:
      {
        programs.wireshark.enable = true;

        users.users = lib.mapAttrs (username: userObj: { extraGroups = [ "wireshark" ]; }) host.users;
      };
  };
}
