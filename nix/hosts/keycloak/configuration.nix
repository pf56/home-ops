{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../base/configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "keycloak";
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  roles.keycloak = {
    enable = true;
    dbPasswordFile = config.sops.secrets.postgresql-password.path;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme" + "@" + "mail" + ".paulfriedrich." + "me";
    defaults.dnsProvider = "cloudflare";
    defaults.dnsResolver = "1.1.1.1:53";
    defaults.credentialsFile = config.sops.secrets.acme-credentials.path;
  };

  sops.secrets = {
    acme-credentials = { };
    postgresql-password = { };
  };

  lollypops.deployment = {
    local-evaluation = true;
    ssh.host = "auth.internal.paulfriedrich.me";
  };

  system.stateVersion = "23.11";
}
