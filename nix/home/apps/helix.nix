{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix = {
    enable = true;

    settings = {
      theme = "nord";
    };
  };
}
