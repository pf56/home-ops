{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
  ];

  networking.hostName = "";

  # display on tty0 instead of serial
  boot.kernelParams = [ "console=tty0" ];

  # add modules to allow booting in a vm
  boot.initrd.kernelModules = [
    "virtio_blk"
    "virtio_pmem"
    "virtio_console"
    "virtio_pci"
    "virtio_mmio"
  ];

  system.stateVersion = "23.05";
}
