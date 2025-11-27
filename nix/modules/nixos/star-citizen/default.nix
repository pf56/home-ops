{
  config,
  pkgs,
  lib,
  inputs,
  perSystem,
  ...
}:

with lib;
let
  cfg = config.modules.star-citizen;
in
{
  imports = [
    inputs.nix-citizen.nixosModules.StarCitizen
  ];

  options.modules.star-citizen = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://nix-citizen.cachix.org" ];
      trusted-public-keys = [ "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo=" ];
    };

    nix-citizen.starCitizen = {
      enable = true;
      package = perSystem.nix-citizen.star-citizen;
    };
  };
}
