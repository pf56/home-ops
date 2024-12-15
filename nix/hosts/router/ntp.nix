{ pkgs, lib, routerConfig, ... }:

let
  inherit (routerConfig) vlans;
in
{
  services.timesyncd.enable = false;
  services.chrony = {
    enable = true;

    extraConfig = ''
      # make chrony act as an NTP server
      allow ${vlans.mgmt.subnet}
      allow ${vlans.office.subnet}
      allow ${vlans.iot.subnet}
      allow ${vlans.server.subnet}
    '';
  };
}
