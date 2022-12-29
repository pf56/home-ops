{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      4646 # HTTP / web ui
      4647 # RPC
      4648 # Serf WAN
    ];

    allowedUDPPorts = [
      4648 # Serf WAN
    ];
  };

  services.nomad = {
    enable = true;
    package = pkgs.nomad_1_4;
    enableDocker = false;

    settings = {
      server = {
        enabled = true;
        bootstrap_expect = 3;
      };
    };
  };
}
