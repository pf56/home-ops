{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.gaming;

  vfio-lutris = pkgs.writeShellScriptBin "vfio-lutris" ''
    export SUDO_ASKPASS=${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass
    sudo -A -g passthru -E lutris
  '';
in
{
  options.modules.gaming = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      vfio-lutris
    ];

    programs = {
      mangohud = {
        enable = true;
        settings = {
          gpu_stats = true;
          gpu_temp = true;
          gpu_core_clock = true;
          gpu_load_change = true;
          gpu_load_value = "50,90";
          gpu_load_color = "8FF0A4,F9F06B,CC0000";
          gpu_power = true;
          gpu_text = "GPU";
          gpu_list = "0,1";

          cpu_stats = true;
          cpu_temp = true;
          cpu_load_change = true;
          cpu_text = "CPU";

          fps = true;
          engine_version = true;
          engine_color = "CDAB8F";
          gpu_name = true;
          gpu_color = "4FB830";
          frame_timing = 1;
          frametime_color = "8FF0A4";

          table_columns = 3;
          text_color = "D8D8D8";
          background_color = "020202";
          background_alpha = 0.8;
          toggle_hud = "Shift_R+F12";
          toggle_logging = "Shift_L+F2";
        };
      };

      lutris = {
        enable = true;
        extraPackages = with pkgs; [
          gamemode
          mangohud
          winetricks
          gamescope
          libnghttp2
          wineWow64Packages.full
        ];
      };
    };
  };
}
