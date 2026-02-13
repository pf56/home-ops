{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        type = "disk";

        content = {
          type = "gpt";
          partitions = {
            boot = {
              type = "EF02";
              size = "1M";
              priority = 1;
            };

            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              size = "100%";
              content = {
                type = "bcachefs";
                filesystem = "main";
                label = "main.root";
                extraFormatArgs = [
                  "--discard"
                ];
              };
            };
          };
        };
      };
    };

    bcachefs_filesystems = {
      main = {
        type = "bcachefs_filesystem";
        passwordFile = "/tmp/secret.key";

        extraFormatArgs = [
          "--compression=lz4"
          "--background_compression=lz4"
        ];

        subvolumes = {
          "@root" = {
            mountpoint = "/";
            mountOptions = [
              "verbose"
            ];
          };
        };
      };
    };
  };
}
