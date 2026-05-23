{ lib, ... }:
{
  den.aspects.ssh = {
    homeManager =
      { pkgs, ... }:
      {
        programs.ssh = {
          enable = true;

          enableDefaultConfig = false;
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

          extraOptionOverrides = {
            # https://unix.stackexchange.com/questions/280879/how-to-get-pinentry-curses-to-start-on-the-correct-tty/499133#499133
            "Match" = "host * exec \"gpg-connect-agent UPDATESTARTUPTTY /bye\"";
          };
        };

      };
  };
}
