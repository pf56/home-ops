{ config, lib, ... }:
{
  programs.git = {
    enable = true;

    signing = {
      key = "65C3EFA544FFF2240FE10EBCBFC5854A6C3CD894";
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
