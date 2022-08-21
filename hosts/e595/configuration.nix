# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration-zfs.nix
    ];

  # use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "nohibernate" ];  # not supported on zfs
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  # general stuff
  networking.hostName = "e595";
  networking.hostId = "5b9c70a7";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };


  # users
  users.users.pfriedrich = {
    isNormalUser = true;
    home = "/home/pfriedrich";
    extraGroups = [ "wheel" "networkmanager" "scanner" "lp" "libvirtd" ];
    shell = pkgs.zsh;
  };

  # system packages
  environment.systemPackages = with pkgs; [
    git
    gnupg
    pavucontrol
    pinentry-curses
    gnome.gedit
  ];

  programs.dconf.enable = true;
  programs.zsh.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
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

  # enable scanner/printer
  hardware.sane.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brgenml1lpr pkgs.brgenml1cupswrapper ];

  virtualisation.libvirtd.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
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
  };


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  services.borgbackup.jobs.home-e595 = {
    repo = "j5g1w103@j5g1w103.repo.borgbase.com:repo";

    paths = [
      "/home"
      "/var/lib"
    ];

    exclude = [
      "/home/*/.cache"
      "/home/*/.config/discord"
      "/var/lib/systemd"
    ];

    prune.keep = {
      within = "1d";
      daily = 7;
      weekly = 4;
      monthly = 6;
    };

    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.sops.secrets.borg_passphrase.path}";
    };

    environment.BORG_RSH = "ssh -i /home/pfriedrich/.ssh/id_ed25519_borg";
    compression = "auto,zstd";
    startAt = "daily";
  };

  services.tailscale.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixFlakes;
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
      borg_passphrase = { };
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

