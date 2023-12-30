{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.eww;
in
{
  imports = [
    ./config
  ];

  options.modules.eww = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.hyprland-workspaces ];

    programs.eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./conf;
    };
  };
}
