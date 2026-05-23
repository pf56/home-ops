{ lib, ... }:
{
  den.aspects.greetd = {
    nixos =
      { pkgs, ... }:
      {
        services.greetd = {
          enable = true;
          useTextGreeter = true;
          settings = {
            default_session = {
              command = "${pkgs.tuigreet}/bin/tuigreet --remember --time --cmd ${pkgs.niri-stable}/bin/niri-session";
              user = "greeter";
            };
          };
        };
      };
  };
}
