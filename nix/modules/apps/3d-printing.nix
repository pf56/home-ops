{ lib, ... }:
{
  den.aspects."3d-printing" = {
    nixos =
      { pkgs, ... }:
      {
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          freecad
          openscad-unstable
          prusa-slicer
        ];

        xdg.dataFile."OpenSCAD/libraries/honeycomb".source = pkgs.openscad-honeycomb;
        xdg.dataFile."OpenSCAD/libraries/round-anything".source = pkgs.openscad-round-anything;
      };
  };
}
