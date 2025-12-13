{ pkgs, config, ... }:
{
  imports = [
    ./alloy.nix
    ./dashboard.nix
    ./prometheus.nix
    ./loki.nix
  ];
}
