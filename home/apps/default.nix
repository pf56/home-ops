{ config, pkgs, lib, ... }:

{
  imports = [
    ./alacritty.nix
    ./vim.nix
    ./wofi.nix
  ];
}
