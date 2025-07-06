{
  config,
  pkgs,
  lib,
  ...
}@inputs:

let
  interfaces = {
    wan = {
      name = "enp1s0";
    };

    ppp = {
      name = "ppp0";
    };

    dslite = {
      name = "dslite";
    };

    lan1 = {
      name = "enp2s0";
    };

    lan2 = {
      name = "enp3s0";
    };

    lan3 = {
      name = "enp4s0";
    };

    tailscale = {
      name = "tailscale0";
    };
  };

  vlans = {
    isp = {
      id = 7;
      name = "vlan7";
    };

    mgmt = {
      id = 10;
      name = "vlan10";
      prefixLength = "24";
      subnet = "10.0.10.0/${vlans.mgmt.prefixLength}";
      gateway = "10.0.10.1";
    };

    office = {
      id = 20;
      name = "vlan20";
      prefixLength = "24";
      subnet = "10.0.20.0/${vlans.office.prefixLength}";
      gateway = "10.0.20.1";
    };

    iot = {
      id = 40;
      name = "vlan40";
      prefixLength = "24";
      subnet = "10.0.40.0/${vlans.iot.prefixLength}";
      gateway = "10.0.40.1";
    };

    server = {
      id = 60;
      name = "vlan60";
      prefixLength = "24";
      subnet = "10.0.60.0/${vlans.server.prefixLength}";
      gateway = "10.0.60.1";
    };
  };

  wellKnowns = {
    dns = "172.16.60.100";
  };

  routerConfig = {
    inherit interfaces vlans wellKnowns;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../base/configuration.nix
    (import ./interfaces.nix (inputs // { inherit routerConfig; }))
    (import ./firewall.nix (inputs // { inherit routerConfig; }))
    (import ./dhcp.nix (inputs // { inherit routerConfig; }))
    (import ./dns.nix (inputs // { inherit routerConfig; }))
    (import ./ntp.nix (inputs // { inherit routerConfig; }))
    (import ./bgp.nix (inputs // { inherit routerConfig; }))
    (import ./tailscale.nix (inputs // { inherit routerConfig; }))
    (import ./ppp.nix (inputs // { inherit routerConfig; }))
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel = {
      sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;
        "net.ipv6.conf.${interfaces.wan.name}.accept_ra" = 2; # https://github.com/tailscale/tailscale/issues/6826
      };
    };
  };

  environment.systemPackages = with pkgs; [
    dhcpm
    dig
    ndisc6
    tcpdump
  ];

  networking = {
    hostName = "router";
  };

  sops.secrets = {
    pppoe-username = { };
    pppoe-password = { };
  };

  lollypops.deployment = {
    local-evaluation = false;
    ssh.host = lib.mkForce "10.0.20.1";
  };

  system.stateVersion = "24.11";
}
