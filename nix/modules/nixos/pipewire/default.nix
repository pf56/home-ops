{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.pipewire;
in
{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

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

      lowLatency = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      qpwgraph
    ];
  };
}
