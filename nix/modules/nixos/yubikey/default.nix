{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.yubikey;
in
{
  options.modules.yubikey = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.yubikey-touch-detector.enable = true;
  };
}
