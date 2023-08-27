{ self, inputs, withSystem, ... }:
let
  system = "x86_64-linux";
  overlay-unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable { inherit system; inherit (final) config; };
  };

  # load all roles from the ./roles directory
  roles = builtins.listToAttrs (map
    (x: {
      name = x;
      value = import (../roles + "/${x}");
    })
    (builtins.attrNames (builtins.readDir ../roles)));

  # the default modules used on every machine
  defaultModules = inputs': [
    { _module.args = inputs'; }
    {
      nixpkgs.overlays = [ overlay-unstable ];
      nix.nixPath = [
        "nixpkgs=${inputs'.nixpkgs}"
      ];

      nix.registry.nixpkgs.flake = inputs'.nixpkgs;
    }
    inputs'.sops-nix.nixosModules.sops
    inputs'.lollypops.nixosModules.lollypops
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
            { nix.nixPath = [ "home-manager=${inputs'.home-manager}" ]; }
            inputs'.home-manager.nixosModules.home-manager
            ../modules/amd
            ./e595/configuration.nix
          ];
        };
  };
}
