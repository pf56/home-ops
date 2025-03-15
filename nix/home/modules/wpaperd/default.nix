{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.wpaperd;
in
{
  options.modules.wpaperd = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    services.wpaperd = {
      enable = true;

      settings = {
        default = {
          path = ./wallpapers/wild.png;
        };
      };
    };
  };
}
