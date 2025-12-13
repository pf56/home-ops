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
    inputs.sops-nix.nixosModules.sops
    flake.nixosModules.amd-gpu
    flake.nixosModules.gaming
    flake.nixosModules.greetd
    flake.nixosModules.kdeconnect
    flake.nixosModules.lollypops-base
    flake.nixosModules.nvme-rs
    flake.nixosModules.obs
    flake.nixosModules.openrgb
    flake.nixosModules.pipewire
    flake.nixosModules.star-citizen
    flake.nixosModules.wireshark
    flake.nixosModules.yubikey
    {
      nix.registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
      nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    }
  ];
}
