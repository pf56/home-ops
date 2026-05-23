{ lib, ... }:
{
  den.aspects.wpaperd = {
    homeManager =
      { pkgs, ... }:
      {
        services.wpaperd = {
          enable = true;
        };
      };
  };
}
