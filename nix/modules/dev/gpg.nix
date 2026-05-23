{ lib, ... }:
{
  den.aspects.gpg = {
    nixos =
      { pkgs, ... }:
      {
      };

    homeManager =
      { pkgs, ... }:
      {
        services.gpg-agent = {
          enable = true;
          pinentry.package = pkgs.pinentry-curses;
          enableSshSupport = true;
        };
      };
  };
}
