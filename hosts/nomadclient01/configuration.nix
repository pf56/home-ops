{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../base/configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nomadclient01";

  roles.vmwareguest.enable = true;

  networking.firewall.trustedInterfaces = [ "docker0" ];
  roles.nomad = {
    enable = true;
    datacenter = "FKB";
    webUi = true;

    server = false;
    docker = true;
    supplementaryGroups = [ ];
    #supplementaryGroups = [ config.users.groups.nomad.name config.users.groups.keys.name ];
  };

  roles.consul = {
    enable = true;
    datacenter = "FKB";
    webUi = false;
    interface = "ens33";
    retryJoin = [
      "consulserver01.internal.paulfriedrich.me"
      "consulserver02.internal.paulfriedrich.me"
      "consulserver03.internal.paulfriedrich.me"
    ];
  };

  # samba users
  users.users.nomadsmb = {
    uid = 1001;
    isSystemUser = true;
    group = "nomadsmb";
  };

  users.groups.nomadsmb = {
    gid = config.users.users.nomadsmb.uid;
  };

  sops.secrets.samba-credentials = {
    sopsFile = ../../secrets/nomadclient.yaml;
    mode = "0440";
    group = "nomadsmb";
  };

  environment.systemPackages = with pkgs; [ cifs-utils ];

  fileSystems."/mnt/apps" = {
    device = "//10.0.60.14/apps";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        uid = config.users.users.nomadsmb.uid;
        gid = config.users.groups.nomadsmb.gid;
      in
      [ "${automount_opts},credentials=${config.sops.secrets.samba-credentials.path},uid=${toString uid},gid=${toString gid}" ];
  };

  fileSystems."/mnt/tv" = {
    device = "//10.0.60.14/tv";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        uid = config.users.users.nomadsmb.uid;
        gid = config.users.groups.nomadsmb.gid;
      in
      [ "${automount_opts},credentials=${config.sops.secrets.samba-credentials.path},uid=${toString uid},gid=${toString gid}" ];
  };

  fileSystems."/mnt/movies" = {
    device = "//10.0.60.14/movies";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        uid = config.users.users.nomadsmb.uid;
        gid = config.users.groups.nomadsmb.gid;
      in
      [ "${automount_opts},credentials=${config.sops.secrets.samba-credentials.path},uid=${toString uid},gid=${toString gid}" ];
  };

  fileSystems."/mnt/temp" = {
    device = "//10.0.60.14/temp";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        uid = config.users.users.nomadsmb.uid;
        gid = config.users.groups.nomadsmb.gid;
      in
      [ "${automount_opts},credentials=${config.sops.secrets.samba-credentials.path},uid=${toString uid},gid=${toString gid}" ];
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.2020-08.org.linux-iscsi.initiatorhost:nomadclient01";
    discoverPortal = "10.0.60.14";
    enableAutoLoginOut = true;

    extraConfig = ''
      node.session.auth.authmethod = CHAP
      node.session.auth.chap_algs = SHA3-256,SHA256,SHA1,MD5
    '';

    extraConfigFile = "${config.lollypops.secrets.files.iscsi-credentials.path}";
  };

  lollypops.secrets.files = {
    iscsi-credentials = {
      cmd = "pass Network/nix/nomadclient/iscsi-credentials";
    };
  };

  fileSystems."/mnt/tandoor" = {
    device = "/dev/disk/by-uuid/103e778c-b317-4821-b46a-d7cf3d2b7992";
    fsType = "ext4";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "_netdev,noatime,discard,${automount_opts}" ];
  };

  system.stateVersion = "22.11";
}
