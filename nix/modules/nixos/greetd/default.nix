{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.greetd;
in
{
  options.modules.greetd = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
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
}
