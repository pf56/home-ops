{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.pipewire;
in
{
  options.modules.pipewire = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
