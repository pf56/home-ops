{
  pkgs,
  ...
}:
pkgs.symlinkJoin {
  name = "openscad-libs";
  paths = [
    inputs.self.openscad-honeycomb
    inputs.self.openscad-round-anything
  ];
}
