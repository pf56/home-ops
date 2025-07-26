{
  config,
  lib,
  flake,
  ...
}:
{
  imports = [
    flake.homeModules.helix
  ];

  services.gpg-agent.sshKeys = [ "FF5C5944BE60F5DCC3B249F761DDD41AF24A1E8B" ];
}
