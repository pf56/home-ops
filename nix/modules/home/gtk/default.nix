{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.gtk;
in
{
  options.modules.gtk = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
    };
  };
}
