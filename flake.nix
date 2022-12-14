{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = github:nix-community/home-manager?ref=release-22.11;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, nixos-generators, ... }: {
    nixosConfigurations.e595 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/e595/configuration.nix
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pfriedrich = import ./home/home.nix;
        }
      ];
    };

    nixosConfigurations.tailscale01 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/tailscale01/configuration.nix
        sops-nix.nixosModules.sops
      ];
    };

    nixosConfigurations.nomadserver-01 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/nomadserver-01/configuration.nix
      ];
    };

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
  };
}
