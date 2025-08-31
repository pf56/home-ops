{
  config,
  pkgs,
  lib,
  options,
  ...
}:

with lib;
let
  cfg = config.modules.vfio;

  gpuVideoBusId = "pci_0000_03_00_0";
  gpuAudioBusId = "pci_0000_03_00_1";
  memory = "32768";

  scriptUnbindDevices = pkgs.writeShellScriptBin "vfio-unbind-devices" ''
    modprobe vfio
    modprobe vfio_iommu_type1
    modprobe vfio_pci

    echo '0000:03:00.0' > '/sys/bus/pci/drivers/amdgpu/unbind'
    echo '0000:03:00.1' > '/sys/bus/pci/drivers/snd_hda_intel/unbind'
  '';

  scriptAllocHugepages = pkgs.writeShellScriptBin "vfio-alloc-hugepages" ''
    ## Calculate number of hugepages to allocate from memory (in MB)
    HUGEPAGES="$((${memory}/$(($(grep Hugepagesize /proc/meminfo | awk '{print $2}')/1024))))"

    echo "Allocating hugepages..."
    echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
    ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

    TRIES=0
    while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
    do
        echo 1 > /proc/sys/vm/compact_memory            ## defrag ram
        echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
        ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
        echo "Succesfully allocated $ALLOC_PAGES / $HUGEPAGES"
        let TRIES+=1
    done

    if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
    then
        echo "Not able to allocate all hugepages. Reverting..."
        echo 0 > /proc/sys/vm/nr_hugepages
        exit 1
    fi
  '';

  scriptDeallocHugepages = pkgs.writeShellScriptBin "vfio-dealloc-hugepages" ''
    echo 0 > /proc/sys/vm/nr_hugepages
  '';
in
{
  options.modules.vfio = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    boot.kernelParams = [ "amd_iommu=on" ];

    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;

          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];

          verbatimConfig = ''
            cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
              "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
              "/dev/kvmfr0"
            ]

            namespaces = []
          '';
        };
      };

      spiceUSBRedirection.enable = true;
    };

    systemd.tmpfiles.rules =
      let
        firmware = pkgs.writeTextDir "firmware/sec-boot-with-ms-keys.json" ''
          {
            "description": "OVMF UEFI firmware",
            "features": [
              "verbose-dynamic",
              "enrolled-keys",
              "acpi-s3",
              "secure-boot",
              "requires-smm"
            ],
            "interface-types": [
              "uefi"
            ],
            "mapping": {
              "device": "flash",
              "executable": {
                "filename": "/run/libvirt/nix-ovmf/OVMF_CODE.ms.fd",
                "format": "raw"
              },
              "nvram-template": {
                "filename": "/run/libvirt/nix-ovmf/OVMF_VARS.ms.fd",
                "format": "raw"
              }
            },
            "tags": [],
            "targets": [
              {
                "architecture": "x86_64",
                "machines": [
                  "pc-q35-*"
                ]
              }
            ]
          }
        '';
      in
      [
        "L+ /var/lib/qemu/firmware - - - - ${firmware}/firmware"
      ];

    users.users.pfriedrich.extraGroups = [ "libvirtd" ];

    # prevent anything from using the GPU. Fixes dynamic bind/unbind of amdgpu.
    users.groups.passthru = { };
    services.udev.extraRules = ''
      KERNEL=="card[0-9]", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", ATTRS{device}=="0x7550", GROUP="passthru", TAG="nothing", ENV{ID_SEAT}="none"
      KERNEL=="renderD12[0-9]", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", ATTRS{device}=="0x7550", GROUP="passthru", MODE="0660"
      KERNEL=="kvmfr[0-9]", SUBSYSTEM=="kvmfr", OWNER="pfriedrich", GROUP="kvm", MODE="0660"
    '';

    # access to GPU can be allowed by 'sudo -A -g passthru command'
    security.sudo.extraRules = [
      {
        users = [ "pfriedrich" ];
        runAs = "ALL:passthru";
        commands = [ "ALL" ];
      }
    ];

    boot.extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];

    environment.etc = {
      "modules-load.d/kvmfr.conf".text = ''
        kvmfr
      '';

      "modprobe.d/kvmfr.conf".text = ''
        options kvmfr static_size_mb=64
      '';
    };

    environment.systemPackages = with pkgs; [
      scriptUnbindDevices
      scriptAllocHugepages
      scriptDeallocHugepages
      scream
    ];

    systemd.user.services.scream = {
      enable = true;
      description = "Scream receiver";

      serviceConfig = {
        ExecStart = "${pkgs.scream}/bin/scream -i virbr0";
        Restart = "always";
      };

      wantedBy = [ "multi-user.target" ];
      requires = [ "pipewire-pulse.service" ];
    };
  };
}
