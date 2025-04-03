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
          radeontop
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

          firmware = with pkgs; [
            (linux-firmware.overrideAttrs (old: {
              src = builtins.fetchGit {
                url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
                rev = "710a336b31981773a3a16e7909fd83daeaec9db1";
              };
            }))
          ];

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
