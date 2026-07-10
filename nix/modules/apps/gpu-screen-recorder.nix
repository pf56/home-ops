{
  den.aspects.gpu-screen-recorder = {
    nixos = { pkgs, ... }: {
      programs.gpu-screen-recorder.enable = true;
      environment.systemPackages = with pkgs; [
        gpu-screen-recorder-gtk
      ];
    };
  };
}
