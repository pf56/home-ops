{ config, pkgs, lib, routerConfig, ... }:

let
  inherit (routerConfig) interfaces vlans wellKnowns;
in
{
  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscaleAuth.path;
    interfaceName = interfaces.tailscale.name;
    disableTaildrop = true;

    extraUpFlags = [
      "--advertise-tags=tag:router"
      "--advertise-exit-node"
      "--advertise-routes=${vlans.iot.subnet},${vlans.server.subnet},${wellKnowns.dns}/32,172.16.61.0/24"
    ];
  };

  sops.secrets = {
    tailscaleAuth = {};
  };
}
