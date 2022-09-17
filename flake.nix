{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = github:nix-community/home-manager?ref=release-22.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, ... }:
  let
    machines = {
      pftest = {
        deployment ={
          targetHost = "10.0.60.103";
        };
      };
    };
    
    colmenaMachine = config: 
      {name, nodes, pkgs, ... }: nixpkgs.lib.recursiveUpdate {
        deployment = {
          targetUser = "pfriedrich";
          buildOnTarget = true;
        };

        imports = [./hosts/${name}/configuration.nix];
      } config;
    

    colmenaMachines = nixpkgs.lib.mapAttrs (name: value: colmenaMachine value) machines;

  in {
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
   

    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
      };
    } // colmenaMachines;
  };
}
