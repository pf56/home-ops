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

  networking.hostName = "ldap01";

  lollypops.deployment.local-evaluation = true;

  networking.firewall.allowedTCPPorts = [ 389 ];

  services.openldap = {
    enable = true;

    settings = {
      attrs = {
        olcLogLevel = "0";
      };

      children = {
        "cn=schema".includes = [
          "${pkgs.openldap}/etc/schema/core.ldif"
          "${pkgs.openldap}/etc/schema/cosine.ldif"
          "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
          "${./rfc2307bis.ldif}"
        ];

        "olcDatabase=mdb".attrs = {
          objectClass = [
            "olcDatabaseConfig"
            "olcMdbConfig"
          ];
          olcDatabase = "mdb";
          olcDbDirectory = "/var/lib/openldap/data";
          olcSuffix = "dc=paulfriedrich,dc=me";
          olcRootDN = "cn=Manager,dc=paulfriedrich,dc=me";
          #olcRootPW.path = config.sops.secrets.openldap-rootpw.path;
          olcRootPW = "secret";
          olcAccess = [
            ''
              to attrs=userPassword
                              by self write 
                              by anonymous auth
                              by dn.base="cn=Manager,dc=paulfriedrich,dc=me" write
                              by * none
            ''
            ''
              to *
                              by self write
                              by dn.base="cn=Manager,dc=paulfriedrich,dc=me" write
                              by * read
            ''
          ];
        };
      };
    };
  };

  system.stateVersion = "23.05";
}
