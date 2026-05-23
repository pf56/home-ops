{ lib, ... }:
{
  den.aspects.bootable =
    {
      uefi ? true,
      ...
    }:
    {
      nixos =
        { pkgs, ... }:
        if uefi then
          {
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;
          }
        else
          {
            boot.loader.grub.enable = true;
          };
    };
}
