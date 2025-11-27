{
  config,
  pkgs,
  lib,
  options,
  flake,
  ...
}:

with lib;
let
  cfg = config.modules.gaming;

  vfio-steam = pkgs.writeShellScriptBin "vfio-steam" ''
    export SUDO_ASKPASS=${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass
    sudo -A -g passthru -E ${pkgs.steam}/bin/steam
  '';
in
{
  imports = [
    flake.nixosModules.steam
  ];

  options.modules.gaming = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        gamemode
        gamescope
        vintagestory
        heroic
        vkdevicechooser
        lsfg-vk
        lsfg-vk-ui
        protonplus

        wowup-cf
      ]
      ++ (lib.optional (builtins.elem "vfio" config.system.nixos.tags) [ vfio-steam ]);

    nixpkgs.config.permittedInsecurePackages = [
      "dotnet-runtime-7.0.20" # vintage story
    ];

    modules = {
      star-citizen.enable = true;
      steam.enable = true;
    };
  };
}
