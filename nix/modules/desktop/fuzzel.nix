{ lib, ... }:
{
  den.aspects.fuzzel = {
    homeManager =
      { pkgs, ... }:
      {
        programs.fuzzel = {
          enable = true;
          settings = {
            main.anchor = "top";
            border.radius = 0;
          };
        };
      };
  };
}
