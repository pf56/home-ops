{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../git.nix
    ../gpg.nix
    ../ssh.nix
    ../utilities.nix
    ../zsh/zsh.nix
  ];

  home.packages = with pkgs; [
    nnn
  ];

}
