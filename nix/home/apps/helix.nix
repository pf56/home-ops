{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix = {
    enable = true;

    settings = {
      theme = "nord";

      keys.normal = {
        c = "change_selection_noyank";
        d = "delete_selection_noyank";
      };

      keys.select = {
        c = "change_selection_noyank";
        d = "delete_selection_noyank";
      };
    };
  };
}
