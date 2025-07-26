{
  pkgs,
  osConfig,
  flake,
  ...
}:
{
  imports = [
    flake.homeModules.profiles-base
    flake.homeModules.home-shared
    flake.homeModules.profiles-desktop
    flake.homeModules.profiles-pfriedrich
  ];
}
