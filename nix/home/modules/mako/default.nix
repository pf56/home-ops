{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.mako;
in
{
  options.modules.mako = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
    };
  };
}
