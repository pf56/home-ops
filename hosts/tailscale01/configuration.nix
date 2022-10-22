{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware-builder.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.fsIdentifier = "label";
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "tailscale01";

  # add users
  users.users.pfriedrich = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3CkovLNkyQNHJIKGfOKDj0Jn6sE0O53qSUw4XOU3U4 pfriedrich@e595"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # enable OpenSSH
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  # setup tailscale
  services.tailscale.enable = true;
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
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      authkey="$(cat ${config.sops.secrets.tailscale_auth_key.path})"
      ${tailscale}/bin/tailscale up --advertise-routes=10.0.60.0/24 --authkey $authkey
    '';
  };

  sops = {
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      tailscale_auth_key = { };
    };
  };

  nix = {
    settings = {
        trusted-public-keys = [ "e595.internal.paulfriedrich.me:BRG0TzHjcB93cncYvpY6ZT4TmFAWPH13MEFRf08y/lc=" ];
    };
  };

  system.stateVersion = "22.05";
}