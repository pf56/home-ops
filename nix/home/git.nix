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
    };
  };
}
