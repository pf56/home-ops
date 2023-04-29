{ config, pkgs, ... }:

let
  k3s = pkgs.k3s.overrideAttrs (old: rec {
    buildInputs = old.buildInputs ++ [ pkgs.openiscsi ];
  });
in
{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "k3s-server-01";

  roles.vmwareguest.enable = true;


  networking.firewall.allowedTCPPorts = [ 6443 ];
  services.k3s.enable = true;
  services.k3s.role = "server";

  systemd.services.k3s.path = with pkgs; [ ipset openiscsi e2fsprogs ];

  services.openiscsi = {
    enable = true;
    name = "iqn.2020-08.org.linux-iscsi.initiatorhost:k3s-server-01";
  };

  environment.systemPackages = with pkgs; [
    nfs-utils
  ];


  system.stateVersion = "22.11";
}
