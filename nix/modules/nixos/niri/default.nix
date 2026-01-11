{
  config,
  pkgs,
  lib,
  options,
  inputs,
  flake,
  ...
}:

with lib;
let
  cfg = config.modules.niri;
in
{
  imports = [
    inputs.niri.nixosModules.niri
    {
      nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    }
  ];

  options.modules.niri = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
    };
  };
}
