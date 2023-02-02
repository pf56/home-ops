# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "ehci_pci" "ahci" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2b0ec7c4-5e0f-47fb-a3e9-6b0370889653";
    fsType = "ext4";
  };

  # data disks
  fileSystems."/media/disk1" = {
    device = "/dev/disk/by-uuid/ab239ab7-4369-4bb2-9463-bf8f0e679e6f";
    fsType = "ext4";
  };

  fileSystems."/media/disk2" = {
    device = "/dev/disk/by-uuid/e38ed864-3f4a-4660-a5af-d8f009fbe255";
    fsType = "ext4";
  };

  fileSystems."/media/disk3" = {
    device = "/dev/disk/by-uuid/e116bb50-90ed-4310-b28a-b2dfe958bc17";
    fsType = "ext4";
  };

  fileSystems."/media/disk4" = {
    device = "/dev/disk/by-uuid/159b4719-259f-4614-945b-4d90bfffff68";
    fsType = "ext4";
  };

  fileSystems."/media/disk5" = {
    device = "/dev/disk/by-uuid/f315b681-ce0b-4ee8-b1d2-d5ae7f8e2022";
    fsType = "ext4";
  };

  fileSystems."/media/disk6" = {
    device = "/dev/disk/by-uuid/d8669dcf-10c1-4ca9-bffd-84b0800e72f7";
    fsType = "ext4";
  };

  # parity disks
  fileSystems."/media/diskp" = {
    device = "/dev/disk/by-uuid/16ed4e44-67da-45dd-8fca-77d6e7f191fa";
    fsType = "ext4";
  };

  fileSystems."/media/diskp2" = {
    device = "/dev/disk/by-uuid/64ab4cce-6d6e-4f53-b7ee-b69b026e4584";
    fsType = "ext4";
  };

  # additional disks
  fileSystems."/media/temp" = {
    device = "/dev/disk/by-uuid/018682eb-4733-4117-8a35-766fcacf3d6b";
    fsType = "ext4";
  };

  # mergerfs
  fileSystems."/storage" = {
    device = "/media/disk[1-6]";
    fsType = "fuse.mergerfs";
    noCheck = true;
    options = [
      "allow_other"
      "use_ino"
      "minfreespace=20G"
      "cache.files=partial"
      "dropcacheonclose=true"
      "category.create=mfs"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens33.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
