{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
with lib;
let
  cfg = config.roles.idm;
in
{
  options = {
    roles.idm = {
      enable = mkEnableOption (mdDoc "Enable identity management");

      domain = mkOption {
        type = types.str;
      };

      nginx = mkOption {
        type = types.nullOr (
          types.submodule (
            import (modulesPath + "/services/web-servers/nginx/vhost-options.nix") {
              inherit config lib;
            }
          )
        );
        default = null;
      };

      certGroup = mkOption {
        type = types.str;
        default = "kanidm-acme";
      };

      proxyDomain = mkOption {
        type = types.str;
      };

      proxyKeyFile = mkOption {
        type = types.path;
      };

      proxyCertGroup = mkOption {
        type = types.str;
        default = "oauth2-proxy";
      };

      proxyNginx = mkOption {
        type = types.nullOr (
          types.submodule (
            import (modulesPath + "/services/web-servers/nginx/vhost-options.nix") {
              inherit config lib;
            }
          )
        );
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {

    services.kanidm = {
      enableServer = true;
      enableClient = true;

      serverSettings = {
        domain = cfg.domain;
        origin = "https://${cfg.domain}";
        role = "WriteReplica";
        tls_key = "/var/lib/acme/${cfg.domain}/key.pem";
        tls_chain = "/var/lib/acme/${cfg.domain}/fullchain.pem";
        bindaddress = "[::1]:8443";
        ldapbindaddress = "0.0.0.0:636";
      };

      clientSettings = {
        uri = "https://${cfg.domain}";
      };
    };

    services.oauth2-proxy = {
      enable = true;
      httpAddress = "0.0.0.0:4180";
      provider = "oidc";
      upstream = [ "static://202" ];
      email.domains = [ "*" ];
      setXauthrequest = true;
      keyFile = cfg.proxyKeyFile;
      reverseProxy = true;
      cookie = {
        name = "__Secure-oauth2_proxy";
        domain = ".internal.paulfriedrich.me";
      };

      tls = {
        enable = true;
        certificate = "/var/lib/acme/${cfg.proxyDomain}/cert.pem";
        key = "/var/lib/acme/${cfg.proxyDomain}/key.pem";
        httpsAddress = "0.0.0.0:41443";
      };

      extraConfig = {
        force-https = true;
        pass-user-headers = true;
        set-authorization-header = true;
        code-challenge-method = "S256";
        whitelist-domain = "*.internal.paulfriedrich.me";
      };
    };

    services.nginx = mkIf (cfg.nginx != null) {
      enable = mkDefault true;

      upstreams."kanidm" = {
        servers = {
          "[::1]:8443" = { };
        };
      };

      upstreams."oauth2-proxy" = {
        servers = {
          "${config.services.oauth2-proxy.tls.httpsAddress}" = { };
        };
      };

      virtualHosts."${cfg.domain}" = mkMerge [
        cfg.nginx
        {
          locations."/" = {
            recommendedProxySettings = true;
            proxyPass = "https://kanidm";
          };
        }
      ];

      virtualHosts."${cfg.proxyDomain}" = mkMerge [
        cfg.proxyNginx
        {
          locations."/" = {
            recommendedProxySettings = true;
            proxyPass = "https://oauth2-proxy";
          };
        }
      ];
    };

    users.groups."${cfg.certGroup}".members = [
      "kanidm"
      "nginx"
    ];
    users.groups."${cfg.proxyCertGroup}".members = [
      "oauth2-proxy"
      "nginx"
    ];
  };
}
