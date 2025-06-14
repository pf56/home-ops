# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
    pipewire.enable = true;
    wireshark.enable = true;
    yubikey.enable = true;
    gaming.enable = true;
    vfio.enable = true;
    greetd.enable = true;
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
      "libvirtd"
      "wireshark"
      "input"
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

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };

  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [
    gcr
    dconf
  ];

  services.pcscd.enable = true;

  # enable scanner/printer
  hardware.sane.enable = true;
  services.printing.enable = true;

  virtualisation.libvirtd.enable = true;

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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    configPackages = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

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
    };
  };

  system.stateVersion = "24.11";
}
