{
  config,
  pkgs,
  lib,
  options,
  ...
}:

with lib;
let
  cfg = config.modules.nvme-rs;
in
{
  options.modules.nvme-rs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };

    smtpPasswordFile = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    services.nvme-rs = {
      enable = true;

      settings = {
        email = {
         from = lib.concatStrings ["status" "@" "mail.paulfriedrich.me"];
         to = lib.concatStrings ["status" "@" "mail.paulfriedrich.me"];

         smtp_server = "smtp.fastmail.com";
         smtp_port = 587;
         smtp_use_tls = true;
         smtp_username = lib.concatStrings ["mail" "@" "paulfriedrich.me"];
         smtp_password_file = "/run/credentials/nvme-rs.service/smtpSecret";
        };
      };
    };

    systemd.services.nvme-rs.serviceConfig.LoadCredential = "smtpSecret:${cfg.smtpPasswordFile}";
  };
}
