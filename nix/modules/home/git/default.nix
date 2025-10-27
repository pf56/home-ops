{ config, lib, ... }:
{
  programs.git = {
    enable = true;

    signing = {
      key = "mail" + "@" + "paulfriedrich.me";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Paul Friedrich";
        email = "mail" + "@" + "paulfriedrich.me";
      };

      init = {
        defaultBranch = "main";
      };

      diff = {
        tool = "bc";
      };

      merge = {
        tool = "bc";
      };

      pull = {
        rebase = true;
      };

      difftool = {
        bc = {
          trustExitCode = true;
        };
      };

      mergetool = {
        bc = {
          trustExitCode = true;
        };
      };
    };
  };
}
