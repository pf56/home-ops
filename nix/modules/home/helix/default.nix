{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix = {
    enable = true;

    settings = {
      editor.file-picker = {
        git-ignore = false;
        git-global = false;
      };

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
