{ config, pkgs, lib, options, ... }:

with lib;
let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gamemode
      gamescope
    ];

    modules.steam.enable = true;
  };
}
