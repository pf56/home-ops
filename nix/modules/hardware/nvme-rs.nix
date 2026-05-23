{ lib, ... }:
{
  den.aspects.nvme-rs = {
    nixos =
      {
        config,
        host,
        pkgs,
        ...
      }:
      {
        services.nvme-rs = {
          enable = true;

          settings = {
            thresholds = {
              temp_warning = 65;
              temp_critical = 80;
            };

            email = {
              from = lib.concatStrings [
                "status"
                "@"
                "mail.paulfriedrich.me"
              ];

              to = lib.concatStrings [
                "status"
                "@"
                "mail.paulfriedrich.me"
              ];

              smtp_server = "smtp.fastmail.com";
              smtp_port = 587;
              smtp_use_tls = true;

              smtp_username = lib.concatStrings [
                "mail"
                "@"
                "paulfriedrich.me"
              ];

              smtp_password_file = "/run/credentials/nvme-rs.service/smtpSecret";
            };
          };
        };

        systemd.services.nvme-rs.serviceConfig.LoadCredential = "smtpSecret:${
          config.sops.secrets."nvme-rs/smtp-password".path
        }";

        sops.secrets."nvme-rs/smtp-password" = { };
      };
  };
}
