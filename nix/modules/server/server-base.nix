{ den, lib, ... }:
{
  den.aspects.server-base = {
    includes = [
      den.aspects.monitoring-client
    ];

    nixos =
      { pkgs, config, ... }:
      {
        boot.growPartition = true;

        security.sudo.wheelNeedsPassword = false;

        # enable OpenSSH
        services.openssh = {
          enable = true;

          settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";
          };
        };

        networking.firewall = {
          enable = lib.mkDefault true;
        };

        sops = {
          age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };

        nix = {
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            auto-optimise-store = true;

            trusted-public-keys = [
              "pizza.internal.paulfriedrich.me:/8ZeJy7jCNTZtVq0a/by4XTGVp7QZS9nPzfDeJ+TvIA="
            ];
          };

          gc = {
            automatic = true;
            options = "--delete-older-than 30d";
          };
        };
      };
  };
}
