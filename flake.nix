{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = github:nix-community/home-manager?ref=release-22.11;
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
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
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

      roles = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./roles + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./roles)));

      hosts = builtins.listToAttrs (map
        (x: {
          name = x;
          value = import (./hosts + "/${x}/configuration.nix");
        })
        (builtins.attrNames (builtins.readDir ./hosts)));

      getHostConfig = (hostConfig: {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable overlay-vscode-extensions ]; })
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          lollypops.nixosModules.lollypops
          snapraid-aio-script.nixosModules.snapraid-aio-script
          { imports = builtins.attrValues roles; }
          hostConfig
        ];
      });

      buildHost = (name: hostConfig: nixpkgs.lib.nixosSystem (getHostConfig hostConfig));
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs buildHost hosts;

      packages.x86_64-linux = {
        vmware = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            lollypops.nixosModules.lollypops
            ./hosts/base/vmware_image.nix
          ];
          format = "vmware";
        };

        virtualbox = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
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
