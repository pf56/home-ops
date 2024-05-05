{ lib, pkgs, config, modulesPath, ... }:
with lib;
let cfg = config.roles.idm;
in
{
  options = {
    roles.idm = {
      enable = mkEnableOption (mdDoc "Enable identity management");

      domain = mkOption {
        type = types.str;
      };

      nginx = mkOption {
        type = types.nullOr (types.submodule
          (import (modulesPath + "/services/web-servers/nginx/vhost-options.nix") {
            inherit config lib;
          }));
        default = null;
      };

      certGroup = mkOption {
        type = types.str;
        default = "kanidm-acme";
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
        ldapbindaddress = null;
      };

      clientSettings = {
        uri = "https://${cfg.domain}";
      };
    };

    services.nginx = mkIf (cfg.nginx != null) {
      enable = mkDefault true;

      upstreams."kanidm" = {
        servers = {
          "[::1]:8443" = { };
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
    };

    users.groups."${cfg.certGroup}".members = [ "kanidm" "nginx" ];
  };
}
