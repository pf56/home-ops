{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.vim = {
    enable = true;

    extraConfig = ''
    '';
  };
}
