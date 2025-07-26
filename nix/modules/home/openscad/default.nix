{
  config,
  pkgs,
  lib,
  perSystem,
  ...
}:

with lib;
let
  cfg = config.modules.openscad;
in
{
  options.modules.openscad = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      openscad-unstable
    ];

    xdg.dataFile."OpenSCAD/libraries/honeycomb".source = perSystem.self.openscad-honeycomb;
    xdg.dataFile."OpenSCAD/libraries/round-anything".source = perSystem.self.openscad-round-anything;
  };
}
