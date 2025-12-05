{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    bat
    direnv
    htop
    (pass.withExtensions (ext: with ext; [ pass-otp ]))
    unzip
    wl-clipboard
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;
  programs.lsd.enable = true;
}
