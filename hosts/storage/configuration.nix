{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "storage";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3260 # iSCSI
    ];
  };

  roles.vmwareguest.enable = true;

  lollypops.deployment.ssh.host = pkgs.lib.mkForce "10.0.60.14";

  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
  ];

  snapraid = {
    enable = true;

    parityFiles = [
      "/media/diskp/snapraid.parity"
      "/media/diskp2/snapraid.parity"
    ];

    dataDisks = {
      d1 = "/media/disk1/";
      d2 = "/media/disk2/";
      d3 = "/media/disk3/";
      d4 = "/media/disk4/";
      d5 = "/media/disk5/";
      d6 = "/media/disk6/";
    };

    contentFiles = [
      "/var/snapraid.content"
      "/media/disk1/snapraid.content"
      "/media/disk2/snapraid.content"
      "/media/disk5/snapraid.content"
    ];

    exclude = [
      "*.unrecoverable"
      "/tmp/"
      "/lost+found/"
      ".AppleDouble"
      "._AppleDouble"
      ".DS_Store"
      ".Thumbs.db"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".AppleDB"
      "/vms/"
      "/downloads/"
      "/luns/"
    ];
  };

  services.snapraid-aio-script = {
    enable = true;
    emailAddress = "status" + "@" + "mail.paulfriedrich.me";
    fromEmailAddress = "status" + "@" + "mail.paulfriedrich.me";
  };

  # samba users
  users.users.nomad = {
    uid = 1001;
    isSystemUser = true;
    group = "nomad";
  };

  users.groups.nomad = {
    gid = config.users.users.nomad.uid;
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";

    extraConfig = ''
      workgroup = WORKGROUP
      map to guest = never
      security = user
      
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 10.0.60. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
    '';

    shares = {
      apps = {
        path = "/storage/apps";
        browseable = "no";
        writable = "yes";

        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "nomad";
      };

      tv = {
        path = "/storage/tv";
        browseable = "no";
        writable = "yes";

        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "nomad";
      };

      movies = {
        path = "/storage/movies";
        browseable = "no";
        writable = "yes";

        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "nomad";
      };

      downloads = {
        path = "/storage/downloads";
        browseable = "no";
        writable = "yes";

        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "nomad";
      };

      temp = {
        path = "/media/temp";
        browseable = "no";
        writable = "yes";

        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "nomad";
      };
    };
  };

  services.target = {
    enable = true;
  };

  programs.msmtp = {
    enable = true;
    accounts.default = {
      auth = true;
      tls = true;
      tls_starttls = false;

      from = "mail" + "@" + "paulfriedrich.me";
      host = "smtp.fastmail.com";
      user = "mail" + "@" + "paulfriedrich.me";
      passwordeval = "cat ${config.sops.secrets.email_password.path}";
    };
  };

  sops.secrets = {
    email_password = {
      mode = "0440";
      group = config.users.groups.keys.name;
    };
  };

  system.stateVersion = "22.11";
}
