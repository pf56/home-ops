{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.ssh = {
    enable = true;

    extraOptionOverrides = {
      # https://unix.stackexchange.com/questions/280879/how-to-get-pinentry-curses-to-start-on-the-correct-tty/499133#499133
      "Match" = "host * exec \"gpg-connect-agent UPDATESTARTUPTTY /bye\"";
    };
  };
}
