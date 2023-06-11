{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../base/configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "tailscale01";

  roles.vmwareguest.enable = true;

  # setup tailscale
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${unstable.tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      authkey="$(cat ${config.sops.secrets.tailscale_auth_key.path})"
      ${unstable.tailscale}/bin/tailscale up --advertise-routes=10.0.60.0/24 --authkey $authkey
    '';
  };

  sops = {
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      tailscale_auth_key = { };
    };
  };

  system.stateVersion = "22.11";
}
