{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "consulserver03";

  roles.vmwareguest.enable = true;

  roles.consul = {
    enable = true;
    datacenter = "FKB";
    webUi = true;
    interface = "ens33";

    server = true;
    bootstrapExpect = 3;
    retryJoin = [
      "consulserver01.internal.paulfriedrich.me"
      "consulserver02.internal.paulfriedrich.me"
      "consulserver03.internal.paulfriedrich.me"
    ];
  };

  system.stateVersion = "22.11";
}
