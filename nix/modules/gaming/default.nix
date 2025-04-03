{ config, pkgs, lib, options, ... }:

with lib;
let
  cfg = config.modules.gaming;

  vfio-steam = pkgs.writeShellScriptBin "vfio-steam" ''
    export SUDO_ASKPASS=${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass
    sudo -A -g passthru -E ${pkgs.steam}/bin/steam
  '';
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
      vfio-steam
      vintagestory
      heroic
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "dotnet-runtime-7.0.20" # vintage story
    ];

    modules.steam.enable = true;
  };
}
