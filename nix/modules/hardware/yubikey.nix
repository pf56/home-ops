{ lib, ... }:
{
  den.aspects.yubikey = {
    nixos =
      { pkgs, ... }:
      {
        programs.yubikey-touch-detector.enable = true;
      };
  };
}
