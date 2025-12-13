{ flake, inputs }:
(
  {
    config,
    pkgs,
    lib,
    ...
  }:

  with lib;
  let
    cfg = config.modules.lollypops-base;
  in
  {
    imports = [
      inputs.lollypops.nixosModules.default
    ];

    options.modules.lollypops-base = {
      enable = mkOption {
        default = true;
        type = types.bool;
      };
    };

    config = mkIf cfg.enable {
      lollypops.deployment = {
        ssh.host = lib.mkDefault "${config.networking.hostName}.internal.paulfriedrich.me";
        ssh.user = lib.mkDefault "pfriedrich";
        sudo.enable = lib.mkDefault true;
      };
    };
  }
)
