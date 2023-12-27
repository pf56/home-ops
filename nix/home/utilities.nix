{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    bat
    direnv
    htop
    (pass.withExtensions (ext: with ext; [ pass-otp ]))
    unzip
    wl-clipboard
  ];

  programs.fzf.enable = true;
  programs.lsd.enable = true;
}
