{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-24.05;
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-wsl.url = github:nix-community/NixOS-WSL/main;
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = github:nix-community/home-manager/release-24.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    lollypops.url = "github:pinpox/lollypops";
    lollypops.inputs.nixpkgs.follows = "nixpkgs";
    talhelper.url = "github:budimanjojo/talhelper";
    talhelper.inputs.nixpkgs.follows = "nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, sops-nix, lollypops, nixos-generators, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        imports = [
          ./nix/hosts/flake-module.nix
        ];

        systems = [ "x86_64-linux" ];

        flake.homeConfigurations = import ./nix/home/profiles { inherit inputs; };
        flake.overlays.default = import ./nix/overlays;

        perSystem = { config, self', inputs', pkgs, system, ... }: {
          apps = {
            default = self'.apps.lollypops;
            lollypops = inputs'.lollypops.apps.default {
              configFlake = self;
            };
          };

          packages = {
            raw-efi = nixos-generators.nixosGenerate {
              system = system;
              modules = [
                sops-nix.nixosModules.sops
                lollypops.nixosModules.lollypops
                ./nix/base/raw-efi_image.nix
              ];
              format = "raw-efi";
            };
          };

          formatter = pkgs.nixpkgs-fmt;
        };
      };
}
