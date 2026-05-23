{ lib, ... }:
{
  den.aspects.wofi = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          wofi
        ];

        home.file = {
          ".config/wofi" = {
            source = ./config;
            recursive = true;
          };
        };
      };
  };
}
