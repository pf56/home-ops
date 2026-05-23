{ den, lib, ... }:
{
  den.aspects.pfriedrich = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
      den.aspects.pfriedrich.policies.auto-host-profile
    ];

    policies.auto-host-profile =
      { host, ... }:
      let
        inherit (den.lib.policy) include;
        role = host.role or null;
      in
      lib.optionals (role == "server") [
        (include den.aspects.pfriedrich-cli)
      ]
      ++ lib.optionals (role == "desktop") [
        (include den.aspects.pfriedrich-cli)
        (include den.aspects.pfriedrich-workstation)
      ];

    homeManager =
      { pkgs, ... }:
      {
        home.username = "pfriedrich";
        home.homeDirectory = "/home/pfriedrich";

        home.packages = with pkgs; [
          dig
          nnn
        ];

        services.gpg-agent.sshKeys = [ "FF5C5944BE60F5DCC3B249F761DDD41AF24A1E8B" ];

        home.stateVersion = "22.05";
      };

    provides.to-hosts.nixos =
      { pkgs, ... }:
      {
        users.users.pfriedrich = {
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHBJYfcGa9cjmJ8SMMqdOny0Bs/4t+pGBXnLk1Pkp+u openpgp:0x77E621AF"
          ];
        };

        virtualisation.vmVariant = {
          users.users.pfriedrich.password = "foo";
        };
      };
  };
}
