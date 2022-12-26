{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 4646 ];
  };

  services.nomad = {
    enable = true;
    package = pkgs.nomad_1_4;
    enableDocker = false;

    settings = {
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };
    };
  };
}
