{ lib, ... }:
{
  den.aspects.backup =
    {
      user ? null,
      ...
    }:
    {
      nixos =
        { config, ... }:
        {
          services.restic.backups.${config.networking.hostName} = {
            repositoryFile = config.sops.secrets.restic_repo.path;
            passwordFile = config.sops.secrets.restic_password.path;
            initialize = true;

            paths = [
              "/home"
              "/var/lib"
            ];

            exclude = [
              "/home/*/.cache"
              "/steam"
              "/var/cache"
              "/var/lib/libvirt/images"
            ]
            ++ lib.optionals (user != null) [
              "/home/${user.userName}/Games"
              "/home/${user.userName}/Videos/Replays"
              "!/home/${user.userName}/Games/Heroic/Prefixes/default/Battle.net/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface"
              "!/home/${user.userName}/Games/Heroic/Prefixes/default/Battle.net/drive_c/Program Files (x86)/World of Warcraft/_retail_/WTF"
            ];

            timerConfig = {
              OnCalendar = "02:00";
              Persistent = true;
              RandomizedDelaySec = "2h";
            };

            pruneOpts = [
              "--keep-daily 7"
              "--keep-weekly 4"
              "--keep-monthly 12"
              "--keep-yearly 15"
            ];

            checkOpts = [
              "--with-cache"
            ];
          };

          sops.secrets = {
            restic_repo = { };
            restic_password = { };
          };
        };
    };
}
