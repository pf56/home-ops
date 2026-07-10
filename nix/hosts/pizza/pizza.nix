{ den, ... }:
{
  den.aspects.pizza = {
    includes = [
      den.aspects.bootable
      den.aspects.backup
      den.aspects.common
      den.aspects.amd-gpu
      den.aspects.appimage
      den.aspects.gaming
      den.aspects.gpu-screen-recorder
      den.aspects.greetd
      den.aspects.niri
      den.aspects.noctalia
      den.aspects.nvme-rs
      den.aspects.openrgb
      den.aspects.obs
      den.aspects.pipewire
      den.aspects.scx
      den.aspects.stylix
      den.aspects.vfio
      den.aspects.wireshark
      den.aspects.yubikey
    ];

    nixos =
      { pkgs, config, ... }:
      {
        imports = [
          ./_hardware-configuration.nix
        ];

        boot.supportedFilesystems = [ "bcachefs" ];
        boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.kernelParams = [ "split_lock_detect=off" ];

        # general stuff
        networking.hostName = "pizza";
        networking.hostId = "f96dc527";

        hardware = {
          enableAllFirmware = true;
          wooting.enable = true;
        };

        sops = {
          age = {
            keyFile = "/var/lib/sops-nix/key.txt";
            generateKey = true;
          };
        };

        system.stateVersion = "24.11";
      };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        # home.packages = [ pkgs.vim ];
      };
  };
}
