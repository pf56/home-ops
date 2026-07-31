{ lib, ... }:
{
  den.aspects."3d-printing" = {
    nixos =
      { pkgs, ... }:
      {
      };

    homeManager =
      { pkgs, inputs', ... }:
      {
        home.packages = with pkgs; [
          inputs'.nixpkgs-stable.legacyPackages.freecad
          prusa-slicer
        ];

        xdg.dataFile."OpenSCAD/libraries/honeycomb".source = pkgs.openscad-honeycomb;
        xdg.dataFile."OpenSCAD/libraries/round-anything".source = pkgs.openscad-round-anything;
      };
  };
}
