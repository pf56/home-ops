{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules._3d-printing;
in
{
  options.modules._3d-printing = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      freecad
      prusa-slicer
    ];

    modules.openscad.enable = true;
  };
}
