{
  config,
  pkgs,
  lib,
  inputs,
  flake,
  ...
}:

{
  imports = with inputs; [
    disko.nixosModules.disko
    ./disk-config.nix
    nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }
    sops-nix.nixosModules.sops
    quadlet-nix.nixosModules.quadlet
    flake.nixosModules.server-base
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "infisical";
  networking.firewall.trustedInterfaces = [ "podman0" ];
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ ];

  virtualisation = {
    quadlet =
      let
        inherit (config.virtualisation.quadlet) networks pods;
      in
      {
        containers.infisical = {
          containerConfig.image = "docker.io/infisical/infisical:v0.155.5";
          containerConfig.environmentFiles = [
            config.sops.secrets.infisical-config.path
            (toString (
              pkgs.writeText "infisival.env" ''
                DB_CONNECTION_URI=postgres://postgres@/infisical?host=/var/run/postgresql
                SITE_URL=https://infisical.internal.paulfriedrich.me
              ''
            ))
          ];

          containerConfig.publishPorts = [ "8080:8080" ];
          containerConfig.volumes = [ "/var/run/postgresql:/var/run/postgresql" ];
        };
      };
  };

  services.redis.servers."infisical" = {
    enable = true;
    bind = "0.0.0.0";
    port = 6379;
    requirePassFile = config.sops.secrets.redis-password.path;
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "infisical" ];
    authentication = lib.mkOverride 10 ''
      #type  database  DBuser  auth-method
      local  all       all     trust
    '';
  };

  services.postgresqlBackup = {
    enable = true;
    databases = [ "infisical" ];
  };

  systemd.services."postgresqlBackup-infisical".requires = [ "infisical-redis-backup.service" ];

  systemd.services."infisical-redis-backup" =
    let
      script = pkgs.writeShellScriptBin "redis-backup" ''
        #!/usr/bin/env bash
        set -euo pipefail

        BACKUP_DIR="${config.services.postgresqlBackup.location}"

        if [ -e "$BACKUP_DIR/redis.rdb" ]; then
          rm -f "$BACKUP_DIR/redis.rdb.prev"
          mv "$BACKUP_DIR/redis.rdb" "$BACKUP_DIR/redis.rdb.prev"
        fi

        export REDISCLI_AUTH=$(< ${config.sops.secrets.redis-password.path})

        echo "Backup up Redis data"
        ${pkgs.redis}/bin/redis-cli \
          -h 127.0.0.1 \
          -p 6379 \
          --rdb "$BACKUP_DIR/redis.rdb"
      '';
    in
    {
      description = "Redis Backup";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${script}/bin/redis-backup";
      };
    };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;

    virtualHosts."infisical.internal.paulfriedrich.me" = {
      forceSSL = true;
      quic = true;

      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "http://infisical";
      };
    };

    upstreams.infisical.servers."localhost:8080" = { };
  };

  services.restic.backups.infisical = {
    repositoryFile = config.sops.secrets.restic-repo.path;
    passwordFile = config.sops.secrets.restic-password.path;
    initialize = true;

    paths = [
      "/var/backup"
    ];

    timerConfig = {
      OnCalendar = "02:00";
      Persistent = true;
      RandomizedDelaySec = "2h";
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
      "--keep-yearly 15"
    ];

    checkOpts = [
      "--with-cache"
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme" + "@" + "mail" + ".paulfriedrich." + "me";
    defaults.dnsProvider = "cloudflare";
    defaults.dnsResolver = "1.1.1.1:53";
    defaults.credentialsFile = config.sops.secrets.acme-credentials.path;
  };

  sops = {
    secrets = {
      infisical-config = { };
      redis-password = { };
      acme-credentials = { };
      restic-repo = { };
      restic-password = { };
    };
  };

  lollypops.deployment.ssh.host = "10.0.60.4";
  system.stateVersion = "26.05";
}
