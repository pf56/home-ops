{
  config,
  pkgs,
  lib,
  options,
  ...
}:

with lib;
let
  cfg = config.modules.steam;
in
{
  options.modules.steam = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
