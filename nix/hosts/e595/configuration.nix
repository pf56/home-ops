# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lollypops, talhelper, profiles, modules, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # general stuff
  networking.hostName = "e595";
  networking.hostId = "5b9c70a7";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  hardware = {
    enableAllFirmware = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    wooting.enable = true;
  };

  modules = {
    amdGpu.enable = true;
    pipewire.enable = true;
    wireshark.enable = true;
    hyprland.enable = true;
    yubikey.enable = true;
  };

  # users
  users.users.pfriedrich = {
    isNormalUser = true;
    home = "/home/pfriedrich";
    extraGroups = [ "wheel" "networkmanager" "scanner" "lp" "libvirtd" "wireshark" "input" ];
    shell = pkgs.zsh;
  };

  # system packages
  environment.systemPackages = with pkgs; [
    git
    gnupg
    pavucontrol
    pinentry-curses
    gedit
    vban
  ];

  programs.dconf.enable = true;
  programs.zsh.enable = true;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = [ "rpool" ];
  services.zfs.autoSnapshot.enable = true;

  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [ gcr dconf ];

  services.pcscd.enable = true;

  # enable scanner/printer
  hardware.sane.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brgenml1lpr pkgs.brgenml1cupswrapper ];

  services = {
    kanidm = {
      enableClient = true;
      clientSettings.uri = "https://auth.internal.paulfriedrich.me";
    };
  };

  virtualisation.libvirtd.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    #    allowedTCPPortRanges = [ { from = 8000; to = 8999; } ];  # packer http server
    checkReversePath = "loose"; # for tailscale
  };

  virtualisation.vmVariant = {
    users.users.pfriedrich.password = "foo";
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  services.restic.backups.e595 = {
    repositoryFile = config.sops.secrets.restic_repo.path;
    passwordFile = config.sops.secrets.restic_password.path;
    initialize = true;

    paths = [
      "/home"
      "/var/lib"
    ];

    exclude = [
      "/home/*/.cache"
      "/home/.zfs"
      "/var/cache"
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

  services.tailscale.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.stable;

    settings = {
      secret-key-files = /home/pfriedrich/.keys/priv-key.pem;
      auto-optimise-store = true;
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
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

