{ den, ... }:
{
  den.ful.homeOps.gpg = {
    nixos =
      { pkgs, ... }:
      {
      };

    homeManager =
      { pkgs, ... }:
      {
        services.gpg-agent = {
          enable = true;
          pinentry.package = pkgs.pinentry-qt;
          enableSshSupport = true;
        };
      };
  };
}
