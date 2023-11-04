{ pkgs, config, ... }:
{
  imports = [
    ./dashboard.nix
    ./prometheus.nix
    ./loki.nix
    ./promtail.nix
  ];
}
