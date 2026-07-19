{ lib, inputs, ... }:
{
  flake-file.inputs.qbz = {
    url = "github:vicrodh/qbz";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.music = {
    homeManager =
      { pkgs, inputs', ... }:
      {
        home.packages = [
          inputs'.qbz.packages.default
        ];
      };
  };
}
