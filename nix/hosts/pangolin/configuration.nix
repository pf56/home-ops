{
  config,
  pkgs,
  lib,
  inputs,
  flake,
  modulesPath,
  ...
}:

{
  imports = with inputs; [
    disko.nixosModules.disko
    ./disk-config.nix
    (modulesPath + "/profiles/qemu-guest.nix")
    sops-nix.nixosModules.sops
    flake.nixosModules.server-base
  ];

  hardware.facter.reportPath = ./facter.json;
  boot.loader.grub.enable = true;

  networking.hostName = "pangolin";

  networking.nftables.enable = true;
  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [
    config.services.tailscale.port
    21820
    51820
  ];

  services.tailscale = {
    enable = true;
    disableTaildrop = true;
    authKeyFile = config.sops.secrets.tailscale-auth.path;
    extraUpFlags = [
      "--accept-routes"
    ];
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  networking.useDHCP = false;
  systemd.network = {
    enable = true;

    networks."10-wan" = {
      matchConfig.MACAddress = "92:00:07:31:66:a7";
      
      address = [
        "46.225.120.169/32"
        "2a01:4f8:1c19:63d::1/64"
      ];

      routes = [
        { Gateway = "fe80::1"; }
        { Gateway = "172.31.1.1"; GatewayOnLink = true; }
      ];

      linkConfig.RequiredForOnline = "routable";
    };
    
    networks."10-lan" = {
      matchConfig.MACAddress = "86:00:00:7b:03:c8";
      
      address = [
        "10.0.1.1/32"
      ];

      routes = [
        { Destination = "10.0.0.0/16"; }
      ];

      linkConfig.RequiredForOnline = "routable";
    };
  };

  services.pangolin = {
    enable = true;
    baseDomain = "ext" + ".paulfriedrich." + "me";
    dnsProvider = "cloudflare";
    environmentFile = config.sops.secrets.pangolin-env.path;

    settings = {
      domains = {
        domain1 = {
          prefer_wildcard_cert = true;
        };
      };

      flags = {
        disable_signup_without_invite = true;
        disable_user_create_org = true;
        enable_integration_api = true;
      };
    };
  };

  services.traefik = {
    environmentFiles = [ config.sops.secrets.traefik-env.path ];
  };

  security.acme = {
    defaults.email = "acme" + "@" + "mail" + ".paulfriedrich." + "me";
  };

  roles.monitoring.alloy = {
    enable = true;
  };

  sops = {
    secrets = {
      tailscale-auth = { };
      "pangolin-env".restartUnits = [ "pangolin.service" ];
      "traefik-env".restartUnits = [ "traefik.service" ];
    };
  };

  lollypops.deployment.ssh.host = "pangolin.tailnet-5ece.ts.net";
  system.stateVersion = "26.05";
}
