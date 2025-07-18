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

  networking.hostName = "ns02";

  lollypops.deployment.ssh.host = lib.mkForce "10.0.60.18";
  lollypops.deployment.local-evaluation = true;

  roles.nameserver = {
    enable = true;
    virtualIp = "172.16.60.100";
    localAS = "4200060018";
    remoteAS = "4200060001";
    remotePeer = "10.0.60.1";
  };

  system.stateVersion = "23.05";
}
