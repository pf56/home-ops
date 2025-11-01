{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.bongocat;

  launchScript = pkgs.writeShellScriptBin "launch-bongocat" ''
    ${pkgs.wayland-bongocat}/bin/bongocat --watch-config --config ${
      config.xdg.configFile."bongocat/config".source
    }
  '';
in
{
  options.modules.bongocat = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wayland-bongocat
      launchScript
    ];

    xdg.configFile."bongocat/config".text = ''
      # Position settings
      cat_x_offset=350  # Horizontal offset from center position
      cat_y_offset=-3  # Vertical offset from default position
      cat_align=right # Horizontal alignment in the bar (left/center/right)

      # Size settings
      cat_height=30 # Height of bongo cat (10-200)

      # Visual settings
      mirror_x=0 # Flip horizontally (mirror across Y axis)
      mirror_y=0 # Flip vertically (mirror across X axis)

      # Anti-aliasing settings
      enable_antialiasing=1 # Use bilinear interpolation for smooth scaling (0=off, 1=on)

      # Overlay settings (requires restart)
      overlay_height=50 # Height of the entire overlay bar (20-300)

      overlay_opacity=0              # Background opacity (0-255)
      overlay_position=top             # Position on screen (top/bottom)
      layer=top                        # Layer type (top/overlay)

      # Animation settings
      idle_frame=0                     # Frame to show when idle (0-3)
      fps=60                           # Frame rate (1-120)
      keypress_duration=100            # Animation duration (ms)
      test_animation_duration=200      # Test animation duration (ms)
      test_animation_interval=0        # Test animation every N seconds (0=off)

      # Input devices (add multiple lines for multiple keyboards)
      keyboard_device=/dev/input/event0  # Keyboard
      keyboard_device=/dev/input/event4  # Mouse
      keyboard_device=/dev/input/event9  # Controller

      # Multi-monitor support
      #monitor=eDP-1                    # Specify which monitor to display on (optional)

      # Sleep mode settings
      enable_scheduled_sleep=0         # Enable scheduled sleep mode (0=off, 1=on)
      sleep_begin=20:00                # Begin of sleeping phase (HH:MM)
      sleep_end=06:00                  # End of sleeping phase (HH:MM)
      idle_sleep_timeout=0             # Inactivity timeout before sleep (seconds, 0=off)

      # Debug
      enable_debug=0                   # Show debug messages
    '';
  };
}
