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
      "Match" = "host * exec \"gpg-connect-agent UPDATESTARTUPTTY /bye\"";
    };
  };
}
