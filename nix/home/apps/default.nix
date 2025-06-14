{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./alacritty.nix
    ./helix.nix
    ./vim.nix
    ./wofi.nix
  ];
}
