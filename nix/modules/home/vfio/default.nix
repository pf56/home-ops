{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.vfio;
in
{
  options.modules.vfio = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs = {
      looking-glass-client = {
        enable = true;
        settings = {
          input = {
            escapeKey = "KEY_F12";
            mouseSmoothing = "no";
          };

          audio = {
            micDefault = "deny";
          };
        };
      };
    };
  };
}
