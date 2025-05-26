{ config, lib, ... }:
{
  programs.git = {
    enable = true;
    userName = "Paul Friedrich";
    userEmail = "mail" + "@" + "paulfriedrich.me";

    signing = {
      key = "mail" + "@" + "paulfriedrich.me";
      signByDefault = true;
    };

    extraConfig = {
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
