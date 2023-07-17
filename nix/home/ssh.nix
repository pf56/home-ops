{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "setKey" = {
        host = "*";
        identityFile = "~/.ssh/id_ed25519";
      };

      "git.internal.paulfriedrich.me" = {
        host = "git.internal.paulfriedrich.me";
        extraOptions = {
          "HostKeyAlgorithms" = "+ssh-rsa";
          "PubKeyAcceptedKeyTypes" = "+ssh-rsa";
        };
      };
    };

    extraOptionOverrides = {
      # https://unix.stackexchange.com/questions/280879/how-to-get-pinentry-curses-to-start-on-the-correct-tty/499133#499133
      "Match" = "host * exec \"gpg-connect-agent UPDATESTARTUPTTY /bye\"";
    };
  };
}
