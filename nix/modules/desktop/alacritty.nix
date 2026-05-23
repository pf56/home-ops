{ lib, ... }:
{
  den.aspects.alacritty = {
    nixos =
      { pkgs, ... }:
      {
      };

    homeManager =
      { pkgs, ... }:
      {
        programs.alacritty = {
          enable = true;
        };
      };
  };
}
