{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8300 # RPC
      8301 # LAN Serf
      8302 # WAN Serf
      8500 # HTTP / web ui
      #8501  # HTTPS / web ui
      #8502  # gRPC
      8600 # DNS
    ];

    allowedTCPPortRanges = [
      {
        # sidecar proxies
        from = 21000;
        to = 21255;
      }
    ];

    allowedUDPPorts = [
      8301 # LAN Serf
      8302 # WAN Serf
      8600 # DNS
    ];

    allowedUDPPortRanges = [
      {
        # sidecar proxies
        from = 21000;
        to = 21255;
      }
    ];
  };

  services.consul = {
    enable = true;
    webUi = true;

    extraConfig = {
      server = false;

      retry_join = [
        "consulserver01.internal.paulfriedrich.me"
        "consulserver02.internal.paulfriedrich.me"
        "consulserver03.internal.paulfriedrich.me"
      ];
    };
  };
}
