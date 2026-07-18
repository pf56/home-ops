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
          helm-ls
          nixd
          yaml-language-server
          yaml-schema-router
        ];

        programs.helix = {
          enable = true;

          languages = {
            language-server.helm_ls = {
              command = "helm_ls";
              args = [ "serve" ];
              environment = {
                "YAMLLS_PATH" = "${lib.getExe pkgs.yaml-schema-router}";
              };
            };

            language-server.nixd = {
              command = "nixd";
            };

            language-server.yaml-schema-router = {
              command = "yaml-schema-router";
              args = [ "--lsp-path ${lib.getExe pkgs.yaml-language-server}" ];
            };

            language = [
              {
                name = "helm";
                language-servers = [ "helm_ls" ];
              }
              {
                name = "nix";
                language-servers = [ "nixd" ];
              }
              {
                name = "yaml";
                language-servers = [ "yaml-schema-router" ];
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
