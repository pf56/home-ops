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
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, sops-nix, home-manager, nixos-generators, ... }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # use this variant if unfree packages are needed:
        # unstable = import nixpkgs-unstable {
        #   inherit system;
        #   config.allowUnfree = true;
        # };
      };

      hosts = rec {
        baseConfig = {
          useHomeManager = false;
        };

        e595 = baseConfig // {
          hostname = "e595";
          useHomeManager = true;
        };

        tailscale01 = baseConfig // {
          hostname = "tailscale01";
        };

        nomadserver01 = baseConfig // {
          hostname = "nomadserver01";
        };

        consulserver01 = baseConfig // {
          hostname = "consulserver01";
        };

        consulserver02 = baseConfig // {
          hostname = "consulserver02";
        };

        consulserver03 = baseConfig // {
          hostname = "consulserver03";
        };
      };

      getHostConfig = (host: {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./hosts/${host.hostname}/configuration.nix
          sops-nix.nixosModules.sops
        ] ++ nixpkgs.lib.optionals host.useHomeManager [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pfriedrich = import ./home/home.nix;
          }
        ];
      });

      buildHost = (name: host: nixpkgs.lib.nixosSystem (getHostConfig host));
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs buildHost hosts;

      packages.x86_64-linux = {
        vmware = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            ./hosts/base/vmware_image.nix
          ];
          format = "vmware";
        };

        virtualbox = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            ./hosts/base/virtualbox_image.nix
          ];
          format = "virtualbox";
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
