{
  config,
  pkgs,
  lib,
  flake,
  ...
}:

with lib;
let
  cfg = config.modules._3d-printing;
in
{
  imports = [
    flake.homeModules.openscad
  ];

  options.modules._3d-printing = {
    enable = mkOption {
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
