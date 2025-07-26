{
  perSystem,
  pkgs,
  pname,
  flake,
  ...
}:
perSystem.lollypops.default.override { configFlake = flake; }
