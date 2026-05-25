{ lib, ... }:
{
  den.aspects.helix = {
    nixos =
      { pkgs, ... }:
      {
      };

    homeManager =
      { pkgs, ... }:
      {
        home.sessionVariables = {
          EDITOR = "hx";
        };

        home.packages = with pkgs; [
          nixd
        ];

        programs.helix = {
          enable = true;

          languages = {
            language-server.nixd = {
              command = "nixd";
            };

            language = [
              {
                name = "nix";
                language-servers = [ "nixd" ];
              }
            ];
          };

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

      };
  };
}
