{ config, pkgs, nix-colors ? import <nix-colors>, lollypops, ... }:

{
  imports = [
    ./apps
    ./gtk.nix
    ./ssh.nix
    ./sway.nix
    ./utilities.nix
    ./zsh/zsh.nix
    #    nix-colors
    lollypops.hmModule
  ];

  # Home Manager
  home.username = "pfriedrich";
  home.homeDirectory = "/home/pfriedrich";

  #  colorScheme = nix-colors.colorSchemes.nord;

  # packages
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    bcompare
    direnv
    discord
    firefox
    helix
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (pass.withExtensions (ext: with ext; [ pass-otp ]))
    terminator
    thunderbird
    trash-cli
    yubikey-manager
    yubikey-touch-detector
  ];

  # configure git
  programs.git = {
    enable = true;
    userName = "Paul Friedrich";
    userEmail = "mail" + "@" + "paulfriedrich.me";
    signing = {
      key = "mail" + "@" + "paulfriedrich.me";
      signByDefault = true;
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };


  # enable font config
  fonts.fontconfig.enable = true;

  # GPG
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSshSupport = true;
    sshKeys = [ "FF5C5944BE60F5DCC3B249F761DDD41AF24A1E8B" ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
