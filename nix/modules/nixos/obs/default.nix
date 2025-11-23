{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.obs;
in
{
  options.modules.obs = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
