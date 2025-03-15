{ self, inputs, withSystem, ... }:
let
  system = "x86_64-linux";
  overlay-unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable { inherit system; inherit (final) config; };
  };

  # load all modules from the ./modules directory
  modules = builtins.listToAttrs (map
    (x: {
      name = x;
      value = import (../modules + "/${x}");
    })
    (builtins.attrNames (builtins.readDir ../modules)));

  # load all roles from the ./roles directory
  roles = builtins.listToAttrs (map
    (x: {
      name = x;
      value = import (../roles + "/${x}");
    })
    (builtins.attrNames (builtins.readDir ../roles)));

  # the default modules used on every machine
  defaultModules = inputs': [
    { _module.args = { inputs = inputs'; }; }
    ({ config, lib, ... }: {
      nixpkgs.overlays = [ overlay-unstable self.overlays.default ];
      nix.registry = lib.mapAttrs (_: value: { flake = value; }) inputs';
      nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    })
    inputs'.sops-nix.nixosModules.sops
    inputs'.lollypops.nixosModules.lollypops
    inputs'.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
    { imports = builtins.attrValues modules; }
    { imports = builtins.attrValues roles; }
  ];

  # build the default system definition
  buildDefaultSystem = inputOverrides: args:
    let
      # allow overriding of the inputs with different versions
      inputs' = (inputs.nixpkgs.lib.recursiveUpdate inputs) inputOverrides;

      inherit (inputs') nixpkgs;
      inherit (inputs'.nixpkgs) lib;
    in
    lib.nixosSystem
      (lib.recursiveUpdate args {
        specialArgs = inputs';
        modules = (defaultModules inputs') ++ args.modules;
      });
in
{
  flake.nixosConfigurations = {
    git = buildDefaultSystem { } {
      modules = [
        ./git/configuration.nix
      ];
    };

    ns02 = buildDefaultSystem { } {
      modules = [ ./ns02/configuration.nix ];
    };

    ldap01 = buildDefaultSystem { } {
      modules = [ ./ldap01/configuration.nix ];
    };

    monitoring = buildDefaultSystem { } {
      modules = [ ./monitoring/configuration.nix ];
    };

    keycloak = buildDefaultSystem { } {
      modules = [ ./keycloak/configuration.nix ];
    };

    auth = buildDefaultSystem { } {
      modules = [ ./auth/configuration.nix ];
    };

    router = buildDefaultSystem { } {
      modules = [ ./router/configuration.nix ];
    };

    e595 =
      let
        inputs' = {
          nixpkgs = inputs.nixpkgs-unstable;
          home-manager = inputs.home-manager-unstable;
        };
      in
      buildDefaultSystem inputs'
        {
          modules = [
            ./e595/configuration.nix
            self.homeConfigurations."pfriedrich@home"
          ];
        };

        
    pizza =
      let
        inputs' = {
          nixpkgs = inputs.nixpkgs-unstable;
          home-manager = inputs.home-manager-unstable;
        };
      in
      buildDefaultSystem inputs'
        {
          modules = [
            ./pizza/configuration.nix
            self.homeConfigurations."pfriedrich@home"
          ];
        };
  };
}
