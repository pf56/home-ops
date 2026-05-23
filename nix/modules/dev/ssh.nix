{ lib, ... }:
{
  den.aspects.ssh = {
    homeManager =
      { options, ... }:
      let
        hasSshSettings = lib.hasAttrByPath [ "programs" "ssh" "settings" ] options;
      in
      {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;

          extraOptionOverrides = {
            # https://unix.stackexchange.com/questions/280879/how-to-get-pinentry-curses-to-start-on-the-correct-tty/499133#499133
            "Match" = "host * exec \"gpg-connect-agent UPDATESTARTUPTTY /bye\"";
          };
        }
        // lib.optionalAttrs hasSshSettings {
          settings."*" = {
            ForwardAgent = false;
            AddKeysToAgent = "no";
            Compression = false;
            ServerAliveInterval = 0;
            ServerAliveCountMax = 3;
            HashKnownHosts = false;
            UserKnownHostsFile = "~/.ssh/known_hosts";
            ControlMaster = "no";
            ControlPath = "~/.ssh/master-%r@%n:%p";
            ControlPersist = "no";
          };
        }
        // lib.optionalAttrs (!hasSshSettings) {
          matchBlocks."*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
        };
      };
  };
}
