{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.openrgb;
in
{
  options.modules.openrgb = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
  };
}
