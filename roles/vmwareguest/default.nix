{ lib, pkgs, config, ... }:
with lib;
let cfg = config.roles.vmwareguest;
in
{
  options = {
    roles.vmwareguest = {
      enable = mkEnableOption (mdDoc "Enable vmware tools");
    };
  };

  config = mkIf cfg.enable {
    virtualisation.vmware.guest.enable = true;
  };
}
