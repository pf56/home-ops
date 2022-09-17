{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware-builder.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.fsIdentifier = "label";
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "pftest";
  time.timeZone = "Europe/Berlin";

  # add users
  users.users.pfriedrich = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3CkovLNkyQNHJIKGfOKDj0Jn6sE0O53qSUw4XOU3U4 pfriedrich@e595"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # enable OpenSSH
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  system.stateVersion = "22.05";
}
