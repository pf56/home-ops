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

          firmware = [
            (pkgs.linux-firmware.overrideAttrs (old: {
              # src = builtins.fetchGit {
              #   url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
              #   rev = "b965e85c15a94974d4a6390972fc1cbc1bb109cc";
              # };
              version = "20260309";
              src = pkgs.fetchurl {
                # https://www.kernel.org/pub/linux/kernel/firmware/
                url = "https://www.kernel.org/pub/linux/kernel/firmware/linux-firmware-20260309.tar.gz";
                # > nix-prefetch-url https://www.kernel.org/pub/linux/kernel/firmware/linux-firmware-20260309.tar.gz
                sha256 = "05jszkqv6i13jl7x9aqkwqi0dwb7h836490s02yysccmz9bipyr8";
              };
            }))
          ];

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
