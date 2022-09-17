{ config, pkgs, lib, ... }:

{
  imports = [
    ./alacritty.nix
    ./vim.nix
    ./vscode.nix
    ./wofi.nix
  ];
}
