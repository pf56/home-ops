{
  flake,
  inputs,
  perSystem,
  pkgs,
  pname,
  ...
}:

inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  format = "iso";

  modules = [
    flake.nixosModules.server-base
  ];
}
