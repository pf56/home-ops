{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
    ../../roles/vmware_guest.nix
    ../../roles/nomad_server.nix
    ../../roles/consul_client.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nomadserver02";

  services.nomad.settings = {
    datacenter = "FKB";
  };

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
