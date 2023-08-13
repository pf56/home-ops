{ self, inputs, withSystem, ... }:
let
  inherit (inputs) nixpkgs;
  inherit (inputs) nixpkgs-unstable;

  inherit (inputs) home-manager;
  inherit (inputs) home-manager-unstable;

  inherit (inputs) sops-nix;
  inherit (inputs) lollypops;
  inherit (inputs) snapraid-aio-script;

  system = "x86_64-linux";
  overlay-unstable = final: prev: {
    unstable = import nixpkgs-unstable { inherit system; inherit (final) config; };
  };

  # load all roles from the ./roles directory
  roles = builtins.listToAttrs (map
    (x: {
      name = x;
      value = import (../roles + "/${x}");
    })
    (builtins.attrNames (builtins.readDir ../roles)));

  # load all hosts and their configuration from the ./hosts directory
  hosts = builtins.listToAttrs (map
    (x: {
      name = x;
      value = import (../hosts + "/${x}/configuration.nix");
    })
    (builtins.attrNames
      (builtins.readDir
        (builtins.filterSource
          (path: type: type == "directory")
          ../hosts))
    ));

  getSystemConfig = (hostConfig: nixpkgsVersion: {
    system = "x86_64-linux";
    specialArgs = inputs;
    modules = [
      {
        nixpkgs.overlays = [ overlay-unstable ];
        nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
        nix.registry.nixpkgs.flake = nixpkgsVersion;
        environment.etc."nix/inputs/nixpkgs".source = nixpkgsVersion.outPath;
      }
      { _module.args = inputs; }
      (if nixpkgsVersion == nixpkgs then home-manager.nixosModules.home-manager else home-manager-unstable.nixosModules.home-manager)
      sops-nix.nixosModules.sops
      lollypops.nixosModules.lollypops
      snapraid-aio-script.nixosModules.snapraid-aio-script
      { imports = builtins.attrValues roles; }
      hostConfig
    ];
  });

  # get the nixpkgs version to use for a specific host
  getNixPkgsForHost = (hostName:
    let
      mapping = {
        "e595" = nixpkgs-unstable;
      };
    in
    if (builtins.hasAttr hostName mapping) then mapping."${hostName}" else nixpkgs);

  # get the host configuration and build nixosSystem
  buildHost = (name: hostConfig:
    let
      nixpkgsVersion = getNixPkgsForHost name;
      systemConfig = (getSystemConfig hostConfig) nixpkgsVersion;
    in
    nixpkgsVersion.lib.nixosSystem systemConfig
  );
in
{
  flake.nixosConfigurations = nixpkgs.lib.mapAttrs buildHost hosts;
}
