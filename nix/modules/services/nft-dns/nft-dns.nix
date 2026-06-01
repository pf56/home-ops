{ den, lib, ... }:
{
  den.aspects.nft-dns = {
    nixos =
      { config, pkgs, ... }:
      let
        cfg = config.services.nft-dns;
        iniFormat = pkgs.formats.ini { };

        mainRuleSections = builtins.filter (section: section != "GLOBAL") (builtins.attrNames cfg.settings);
        extraRuleSections = builtins.concatMap (
          fileCfg: builtins.filter (section: section != "GLOBAL") (builtins.attrNames fileCfg)
        ) (builtins.attrValues cfg.extraConfigFiles);

        defaultSettings = lib.optionalAttrs (cfg.extraConfigFiles != { }) {
          GLOBAL = {
            include_config_dir = "/etc/nft-dns.d";
          };
        };

        mainConfig = iniFormat.generate "nft-dns.conf" (lib.recursiveUpdate defaultSettings cfg.settings);
      in
      {
        options.services.nft-dns = {
          enable = lib.mkEnableOption (lib.mdDoc "nft-dns") // {
            description = lib.mdDoc ''
              Keep nftables sets in sync with DNS records.
              See `man nft-dns for details about supported configuration fields.
            '';
          };

          package = lib.mkPackageOption pkgs "nft-dns" { };

          settings = lib.mkOption {
            type = iniFormat.type;
            default = { };
            description = lib.mdDoc ''
              Main `nft-dns` configuration written to `/etc/nft-dns.conf`.
            '';
            example = {
              GLOBAL = {
                min_ttl = 60;
                max_ttl = 3600;
              };

              debian = {
                enable = true;
                set_name = "ALLOW-DNS";
                family = "ip";
                table = "filter";
                domains = "deb.debian.org,security.debian.org";
              };
            };
          };

          extraConfigFiles = lib.mkOption {
            type = lib.types.attrsOf iniFormat.type;
            default = { };
            description = lib.mdDoc ''
              Additional config files written to `/etc/nft-dns.d/<name>.conf`.
            '';
            example = {
              custom = {
                github = {
                  enable = true;
                  set_name = "ALLOW-GITHUB";
                  family = "ip";
                  table = "filter";
                  domains = "github.com";
                };
              };
            };
          };
        };

        config = lib.mkIf cfg.enable {
          assertions = [
            {
              assertion = (mainRuleSections != [ ]) || (extraRuleSections != [ ]);
              message = "services.nft-dns requires at least one non-GLOBAL section in settings or extraConfigFiles.";
            }
          ];

          environment.etc = {
            "nft-dns.conf".source = mainConfig;
          }
          // lib.mapAttrs' (
            name: fileCfg:
            lib.nameValuePair "nft-dns.d/${name}.conf" {
              source = iniFormat.generate "nft-dns-${name}.conf" fileCfg;
            }
          ) cfg.extraConfigFiles;

          environment.systemPackages = [ cfg.package ];

          systemd.services.nft-dns = {
            description = "NFTables DNS support";
            wantedBy = [ "multi-user.target" ];
            wants = [ "network-online.target" ];
            after = [
              "nftables.service"
              "network-online.target"
            ];
            requires = [ "nftables.service" ];
            path = [ pkgs.nftables ];

            serviceConfig = {
              Type = "simple";
              ExecStart = "${lib.getExe cfg.package} --config /etc/nft-dns.conf";
              Restart = "on-failure";
            };
          };
        };
      };
  };
}
