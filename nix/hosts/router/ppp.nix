{
  pkgs,
  lib,
  config,
  routerConfig,
  ...
}:

let
  inherit (routerConfig) vlans;
in
{
  services.pppd = {
    enable = true;
    peers = {
      isp = {
        autostart = true;
        enable = true;
        config = ''
          # set via sops template
        '';
      };
    };
  };

  environment.etc = {
    # file needs to exist
    "ppp/options".text = '''';

    "ppp/peers/isp" = {
      source = lib.mkForce config.sops.templates."pppoe-peers-isp".path;
      mode = "0444";
    };

    "ppp/chap-secrets".source = config.sops.templates."pppoe-chap-secrets".path;
  };

  sops.templates = {
    "pppoe-peers-isp".content = ''
      plugin pppoe.so

      # interface to use
      ${vlans.isp.name}

      # username
      name ${config.sops.placeholder.pppoe-username}

      persist
      maxfail 0
      holdoff 5

      noipdefault
      defaultroute

      debug
    '';

    "pppoe-chap-secrets".content = ''
      ${config.sops.placeholder.pppoe-username} * ${config.sops.placeholder.pppoe-password}
    '';
  };
}
