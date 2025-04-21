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
    mkIf cfg.enable
      {
        environment.systemPackages = with pkgs; [
          clinfo
          glxinfo
          radeontop
          vulkan-tools
        ];

        hardware = {
          graphics = {
            enable = true;
            enable32Bit = true;

            extraPackages = with pkgs; [
              vaapiVdpau
              libvdpau-va-gl
            ];

            extraPackages32 = with pkgs; [
              vaapiVdpau
              libvdpau-va-gl
            ];
          };

          amdgpu.initrd.enable = true;
          amdgpu.amdvlk.enable = true;
        };

        programs = {
          corectrl = {
            enable = true;
            gpuOverclock.enable = true;
          };
        };
      };
}
