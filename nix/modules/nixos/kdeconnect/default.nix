{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.kdeconnect;
in
{
  options.modules.kdeconnect = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.kdeconnect.enable = true;
  };
}
