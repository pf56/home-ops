{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = github:nix-community/home-manager/release-23.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    lollypops.url = "github:pinpox/lollypops";
    lollypops.inputs.nixpkgs.follows = "nixpkgs";
    talhelper.url = "github:budimanjojo/talhelper";
    talhelper.inputs.nixpkgs.follows = "nixpkgs";

    snapraid-aio-script = {
      url = "sourcehut:~pf56/snapraid-aio-script-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, sops-nix, home-manager, home-manager-unstable, nixos-generators, lollypops, snapraid-aio-script, ... }@attrs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable { inherit system; inherit (final) config; };
      };

      overlay-vscode-extensions = final: prev:
        let
          inherit (nixpkgs.legacyPackages.${system}.vscode-utils) buildVscodeMarketplaceExtension;
        in
        {
          vscode-cust-extensions = {
            hashicorp.hcl = buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "hcl";
                publisher = "hashicorp";
                version = "0.3.2";
                sha256 = "731177927618dbd3ef4f7ae4452f121b1327f6fcede7ac30057a64d8fa8ed26a";
              };
            };
          };
        };


      # load all roles from the ./roles directory
      roles = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./nix/roles + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./nix/roles)));

      # load all hosts and their configuration from the ./hosts directory
      hosts = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./nix/hosts + "/${x}/configuration.nix");
        })
        (builtins.attrNames (builtins.readDir ./nix/hosts)));

      getSystemConfig = (hostConfig: nixpkgsVersion: {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          {
            nixpkgs.overlays = [ overlay-unstable overlay-vscode-extensions ];
            nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
            nix.registry.nixpkgs.flake = nixpkgsVersion;
            environment.etc."nix/inputs/nixpkgs".source = nixpkgsVersion.outPath;
          }
          { _module.args = attrs; }
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
      nixosConfigurations = nixpkgs.lib.mapAttrs buildHost hosts;

      packages.x86_64-linux = {
        vmware = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            lollypops.nixosModules.lollypops
            ./nix/base/vmware_image.nix
          ];
          format = "vmware";
        };

        virtualbox = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            lollypops.nixosModules.lollypops
            ./nix/base/virtualbox_image.nix
          ];
          format = "virtualbox";
        };

        raw-efi = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            lollypops.nixosModules.lollypops
            ./nix/base/raw-efi_image.nix
          ];
          format = "raw-efi";
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      apps.x86_64-linux.default = lollypops.apps.x86_64-linux.default {
        configFlake = self;
      };
    };
}
