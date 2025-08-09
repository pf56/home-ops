{
  config,
  pkgs,
  lib,
  inputs,
  flake,
  ...
}:

{
  imports = [
    flake.nixosModules.lollypops-base
    {
      nix.registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
      nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    }
  ];
}
