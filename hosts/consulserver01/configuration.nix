{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
    ../../roles/vmware_guest.nix
    ../../roles/consul_server.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "consulserver01";

  services.consul = {
    extraConfig.datacenter = "FKB";
    interface =
      {
        bind = "ens33";
        advertise = "ens33";
      };
  };

  system.stateVersion = "22.11";
}
