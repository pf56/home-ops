{
  den,
  lib,
  inputs,
  ...
}:
{
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
  };

  den.default = {
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
          inputs.nixos-facter-modules.nixosModules.facter
          (
            {
              lib,
              config,
              pkgs,
              ...
            }:
            let
              registryInputs = builtins.removeAttrs inputs [
                "nixpkgs"
                "nixpkgs-stable"
              ];
            in
            {
              nix.registry = (lib.mapAttrs (_: value: { flake = value; }) registryInputs) // {
                nixpkgs.to = {
                  type = "path";
                  path = pkgs.path;
                };
                nixpkgs-unstable.flake = inputs.nixpkgs;
                nixpkgs-stable.flake = inputs.nixpkgs-stable;
              };
              nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
            }
          )
        ];

        nixpkgs.overlays = builtins.attrValues inputs.self.overlays;

        sops.defaultSopsFile = lib.mkDefault ../../secrets/${config.networking.hostName}.yaml;

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        system.stateVersion = lib.mkDefault "25.11";
      };

    homeManager =
      { config, ... }:
      {
        programs.home-manager.enable = true;
        home.stateVersion = lib.mkDefault "25.11";
      };
  };

  # enable hm by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
  den.schema.user.includes = [ den._.host-aspects ];
}
