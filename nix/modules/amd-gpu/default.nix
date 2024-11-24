{ config, pkgs, lib, options, ... }:

with lib;
let
  cfg = config.modules.amdGpu;
in
{
  options.modules.amdGpu = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
      };
  };

  config =
    let
      extraPkgs = with pkgs; [
        rocmPackages.clr.icd
        amdvlk
      ];
    in
    mkIf cfg.enable
      {

        boot.initrd.kernelModules = [ "amdgpu" ];

        environment.systemPackages = with pkgs; [
          clinfo
          radeontop
        ];

        systemd.tmpfiles.rules = [
          "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
        ];
      } // optionalAttrs (builtins.hasAttr "graphics" options.hardware) {
      hardware.graphics = {
        extraPackages = extraPkgs;
      } // optionalAttrs (builtins.hasAttr "opengl" options.hardware) {
        hardware.opengl = {
          extraPackages = extraPkgs;
        };
      };
    };
}
