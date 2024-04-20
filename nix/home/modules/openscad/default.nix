{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.openscad;
in
{
  options.modules.openscad = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      openscad-unstable
    ];

    xdg.dataFile."OpenSCAD/libraries/honeycomb".source = pkgs.openscadLibs.honeycomb;
    xdg.dataFile."OpenSCAD/libraries/round-anything".source = pkgs.openscadLibs.round-anything;
  };
}
