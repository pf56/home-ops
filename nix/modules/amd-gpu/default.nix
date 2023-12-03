{ config, pkgs, lib, ... }:

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

  config = mkIf cfg.enable {

    boot.initrd.kernelModules = [ "amdgpu" ];

    environment.systemPackages = with pkgs; [
      clinfo
      radeontop
    ];

    hardware.opengl = {
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        amdvlk
      ];
    };

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}
