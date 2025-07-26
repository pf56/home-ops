{
  flake,
  perSystem,
  pkgs,
  pname,
  ...
}:
pkgs.symlinkJoin {
  name = pname;
  paths = [
    perSystem.self.openscad-honeycomb
    perSystem.self.openscad-round-anything
  ];
}
