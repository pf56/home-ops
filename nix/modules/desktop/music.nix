{ lib, inputs, ... }:
{
  den.aspects.music = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
        ];
      };
  };
}
