{ config, lib, ... }:
{
  imports = [
    ../git.nix
    ../gpg.nix
    ../ssh.nix
    ../utilities.nix
    ../zsh/zsh.nix
  ];
}
