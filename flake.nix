{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = github:nix-community/home-manager/release-23.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    lollypops.url = "github:pinpox/lollypops";
    lollypops.inputs.nixpkgs.follows = "nixpkgs";

    snapraid-aio-script = {
      url = "sourcehut:~pf56/snapraid-aio-script-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, sops-nix, home-manager, nixos-generators, lollypops, snapraid-aio-script, ... }@attrs:
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

      overlay-bcompare = final: prev: {
        bcompare = prev.bcompare.overrideAttrs (finalAttrs: prevAttrs: {
          version = "4.4.6-27483";
          src = final.fetchurl {
            url = "https://www.scootersoftware.com/files/bcompare-4.4.6.27483_amd64.deb";
            sha256 = "0j83kqj9xvvffw70a6363m6swfld8d9b670yb4s9zwc9zh0zzryp";
          };
        });
      };

      # load all roles from the ./roles directory
      roles = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./roles + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./roles)));

      # load all hosts and their configuration from the ./hosts directory
      hosts = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./hosts + "/${x}/configuration.nix");
        })
        (builtins.attrNames (builtins.readDir ./hosts)));

      getHostConfig = (hostConfig: nixpkgsVersion: {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          {
            nixpkgs.overlays = [ overlay-unstable overlay-vscode-extensions overlay-bcompare ];
            nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
            nix.registry.nixpkgs.flake = nixpkgsVersion;
            environment.etc."nix/inputs/nixpkgs".source = nixpkgsVersion.outPath;
          }
          home-manager.nixosModules.home-manager
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
          systemConfig = (getHostConfig hostConfig) nixpkgsVersion;
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
            ./hosts/base/vmware_image.nix
          ];
          format = "vmware";
        };

        virtualbox = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            lollypops.nixosModules.lollypops
            ./hosts/base/virtualbox_image.nix
          ];
          format = "virtualbox";
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      apps.x86_64-linux.default = lollypops.apps.x86_64-linux.default {
        configFlake = self;
      };
    };
}
