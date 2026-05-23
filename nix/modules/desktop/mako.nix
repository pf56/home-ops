{ lib, ... }:
{
  den.aspects.mako = {
    homeManager =
      { pkgs, ... }:
      {
        services.mako = {
          enable = true;
        };

      };
  };
}
