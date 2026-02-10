{
  inputs,
  flake,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    flake.nixosModules.host-base
    flake.nixosModules.niri
    flake.nixosModules.vfio
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "bcachefs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "split_lock_detect=off" ];

  # general stuff
  networking.hostName = "pizza";
  networking.hostId = "f96dc527";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  hardware = {
    enableAllFirmware = true;
    wooting.enable = true;
  };

  modules = {
    amdGpu.enable = true;
    gaming.enable = true;
    greetd.enable = true;
    kdeconnect.enable = true;
    niri.enable = true;
    nvme-rs = {
      enable = true;
      smtpPasswordFile = config.sops.secrets.smtp_password.path;
    };
    openrgb.enable = true;
    obs.enable = true;
    pipewire.enable = true;
    vfio.enable = true;
    wireshark.enable = true;
    yubikey.enable = true;
  };

  # users
  users.users.pfriedrich = {
    isNormalUser = true;
    home = "/home/pfriedrich";
    extraGroups = [
      "wheel"
      "networkmanager"
      "scanner"
      "lp"
      "wireshark"
      "input"
      config.programs.ydotool.group
    ];
    shell = pkgs.zsh;
  };

  # system packages
  environment.systemPackages = with pkgs; [
    git
    gnupg
    pavucontrol
    pinentry-curses
    gedit
    easyeffects
    qpwgraph
  ];

  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.ydotool.enable = true;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };

  services.fwupd.enable = true;

  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [
    gcr
    dconf
  ];

  services.pcscd.enable = true;

  services.bcachefs.autoScrub = {
    enable = true;
  };

  services.angrr = {
    enable = true;

    settings = {
      temporary-root-policies = {
        direnv = {
          path-regex = "/\\.direnv/";
          period = "14d";
        };

        result = {
          path-regex = "/result[^/]*$";
          period = "3d";
        };
      };

      profile-policies.user = {
        enable = false;
        profile-paths = [ ];
      };

      profile-policies.system = {
        enable = false;
        profile-paths = [ ];
      };
    };
  };

  # enable scanner/printer
  hardware.sane.enable = true;
  services.printing.enable = true;

  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  networking.firewall = {
    enable = true;
    trustedInterfaces = [
      "virbr0"
      #"tailscale0"
    ];

    #allowedUDPPorts = [ config.services.tailscale.port ];
    #    allowedTCPPortRanges = [ { from = 8000; to = 8999; } ];  # packer http server
    #checkReversePath = "loose"; # for tailscale
  };

  services.restic.backups.pizza = {
    repositoryFile = config.sops.secrets.restic_repo.path;
    passwordFile = config.sops.secrets.restic_password.path;
    initialize = true;

    paths = [
      "/home"
      "/var/lib"
    ];

    exclude = [
      "/home/*/.cache"
      "/home/pfriedrich/Games"
      "/steam"
      "/var/cache"
      "/var/lib/libvirt/images"
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

  virtualisation.vmVariant = {
    users.users.pfriedrich.password = "foo";
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.stable;

    settings = {
      secret-key-files = /var/cache-priv-key.pem;
      auto-optimise-store = true;
      substituters = [ "https://ghostty.cachix.org" ];
      trusted-public-keys = [
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  sops = {
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;

    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      restic_repo = { };
      restic_password = { };
      smtp_password = { };
    };
  };

  system.stateVersion = "24.11";
}
