{ lib, ... }:
{
  den.aspects.amd-gpu = {
    nixos =
      { pkgs, options, ... }:
      {
        environment.systemPackages = with pkgs; [
          clinfo
          mesa-demos
          radeontop
          vulkan-tools
        ];

        hardware = {
          graphics = {
            enable = true;
            enable32Bit = true;

            extraPackages = with pkgs; [
              libva-vdpau-driver
              libvdpau-va-gl
            ];

            extraPackages32 = with pkgs; [
              libva-vdpau-driver
              libvdpau-va-gl
            ];
          };

          amdgpu.initrd.enable = true;
          amdgpu.amdvlk.enable = true;
        }
        // lib.optionalAttrs (builtins.hasAttr "overdrive" options.hardware.amdgpu) {
          amdgpu.overdrive.enable = true;
        };

        programs = {
          corectrl = {
            enable = true;
          };
        };
      };
  };
}
