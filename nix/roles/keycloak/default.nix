{ lib, pkgs, config, ... }:
with lib;
let cfg = config.roles.keycloak;
in
{
  options = {
    roles.keycloak = {
      enable = mkEnableOption (mdDoc "Enable keycloak");

      domain = mkOption {
        type = types.str;
        default = "auth.internal.paulfriedrich.me";
      };

      dbPasswordFile = mkOption {
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    services.keycloak = {
      enable = true;

      database = {
        createLocally = true;
        type = "postgresql";
        username = "keycloak";
        passwordFile = cfg.dbPasswordFile;
      };

      settings = {
        hostname = cfg.domain;
        hostname-strict-backchannel = true;
        proxy = "edge";
        http-port = 8080;
        https-port = 8443;
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

      upstreams."keycloak" = {
        servers = {
          "127.0.0.1:${toString config.services.keycloak.settings.http-port}" = { };
        };
      };

      virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        quic = true;

        enableACME = true;
        acmeRoot = null;

        locations."/" = {
          proxyPass = "http://keycloak";
        };
      };
    };
  };
}
