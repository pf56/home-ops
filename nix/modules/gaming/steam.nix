{ lib, ... }:
{
  den.aspects.steam = {
    nixos =
      { pkgs, ... }:
      {
        programs.steam = {
          enable = true;
          protontricks.enable = true;
          localNetworkGameTransfers.openFirewall = true;
        };
      };

    homeManager =
      { pkgs, ... }:
      {

      };
  };
}
