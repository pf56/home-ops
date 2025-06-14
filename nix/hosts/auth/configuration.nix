{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../base/configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "auth";
  networking.firewall.allowedTCPPorts = [
    80
    443
    636
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  roles = {
    idm = {
      enable = true;
      domain = "auth.internal.paulfriedrich.me";
      nginx = {
        forceSSL = true;
        quic = true;
        useACMEHost = config.roles.idm.domain;
      };

      proxyDomain = "auth-proxy.internal.paulfriedrich.me";
      proxyKeyFile = config.sops.secrets.oauth2-proxy-credentials.path;
      proxyNginx = {
        forceSSL = true;
        quic = true;
        useACMEHost = config.roles.idm.proxyDomain;
      };
    };
  };

  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;

    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedZstdSettings = true;
    recommendedBrotliSettings = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme" + "@" + "mail" + ".paulfriedrich." + "me";
    defaults.dnsProvider = "cloudflare";
    defaults.dnsResolver = "1.1.1.1:53";
    defaults.credentialsFile = config.sops.secrets.acme-credentials.path;

    certs."${config.roles.idm.domain}" = {
      group = config.roles.idm.certGroup;
    };

    certs."${config.roles.idm.proxyDomain}" = {
      group = config.roles.idm.proxyCertGroup;
    };
  };

  sops.secrets = {
    acme-credentials = { };
    oauth2-proxy-credentials = { };
  };

  lollypops.deployment = {
    local-evaluation = true;
  };

  system.stateVersion = "23.11";
}
