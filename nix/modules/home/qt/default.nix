{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.qt;
in
{
  options.modules.qt = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile = {
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Nordic
      '';

      "Kvantum/Nordic".source = "${pkgs.nordic}/share/Kvantum/Nordic";
    };
  };
}
