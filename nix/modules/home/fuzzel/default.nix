{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.fuzzel;
in
{
  options.modules.fuzzel = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main.anchor = "top";
        border.radius = 0;
      };
    };
  };
}
