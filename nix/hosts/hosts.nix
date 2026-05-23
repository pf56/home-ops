{ den, inputs, ... }:
let
  nixosUnstable = inputs.nixpkgs.lib.nixosSystem;
  nixosStable = inputs.nixpkgs-stable.lib.nixosSystem;
  homeManagerUnstable = inputs.home-manager.nixosModules.home-manager;
  homeManagerStable = inputs.home-manager-stable.nixosModules.home-manager;
in
{
  den.hosts.x86_64-linux.pizza = {
    instantiate = nixosUnstable;
    home-manager.module = homeManagerUnstable;
    role = "desktop";
    users.pfriedrich = { };
  };

  den.hosts.x86_64-linux.ns02 = {
    instantiate = nixosStable;
    home-manager.module = homeManagerStable;
    role = "server";
    users.pfriedrich = { };
  };

  den.hosts.x86_64-linux.router = {
    instantiate = nixosUnstable;
    home-manager.module = homeManagerUnstable;
    role = "server";
    users.pfriedrich = { };
  };

  den.hosts.x86_64-linux.monitoring = {
    instantiate = nixosStable;
    home-manager.module = homeManagerStable;
    role = "server";
    users.pfriedrich = { };
  };

  den.hosts.x86_64-linux.infisical = {
    instantiate = nixosUnstable;
    home-manager.module = homeManagerUnstable;
    role = "server";
    users.pfriedrich = { };
  };

  den.hosts.x86_64-linux.pangolin = {
    instantiate = nixosUnstable;
    home-manager.module = homeManagerUnstable;
    role = "server";
    users.pfriedrich = { };
  };
}
