{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.wireshark;
in
{
  options.modules.wireshark = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    programs.wireshark.enable = true;
  };
}
