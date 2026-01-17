{
  description = "Simple flake with a devshell";

  inputs = {
    blueprint = {
      url = "github:numtide/blueprint";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    sops-nix.url = "github:Mic92/sops-nix";
    lollypops.url = "github:pinpox/lollypops";
    talhelper.url = "github:budimanjojo/talhelper";
    disko.url = "github:nix-community/disko/latest";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    grafana-dashboards.url = "github:blackheaven/grafana-dashboards.nix";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      prefix = "nix/";
    };
}
