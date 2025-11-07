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
    mission-center
    slurp
    xclip
  ];
}
