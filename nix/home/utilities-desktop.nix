{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    evince
    grim
    slurp
  ];
}
