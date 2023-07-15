{ config, pkgs, lib, ... }:

{
  imports = [
    ./alacritty.nix
    ./helix.nix
    ./vim.nix
    ./vscode.nix
    ./wofi.nix
  ];
}
