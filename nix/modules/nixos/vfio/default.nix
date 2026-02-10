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

  memory = "32768";

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

    users.users.pfriedrich.extraGroups = [ "libvirtd" ];

    users.groups.passthru = { };
    services.udev.extraRules = ''
      KERNEL=="kvmfr[0-9]", SUBSYSTEM=="kvmfr", OWNER="pfriedrich", GROUP="kvm", MODE="0660"
    '';

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
