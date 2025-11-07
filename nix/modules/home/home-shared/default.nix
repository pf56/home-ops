{
  config,
  pkgs,
  inputs,
  flake,
  perSystem,
  ...
}:

{
  imports = [
    inputs.lollypops.homeModules.default
    flake.homeModules."3d-printing"
    flake.homeModules.alacritty
    flake.homeModules.helix
    flake.homeModules.vim
    flake.homeModules.wofi
  ];

  # Home Manager
  home.username = "pfriedrich";
  home.homeDirectory = "/home/pfriedrich";

  # packages
  home.packages = with pkgs; [
    bcompare
    (discord-canary.override (old: rec {
      withVencord = true;
    }))
    discover-overlay
    firefox
    jetbrains.rider
    k9s
    terminator
    thunderbird
    trash-cli
    yubikey-manager
    yubikey-touch-detector

    # helix + language servers
    helix
    nodePackages.yaml-language-server
    omnisharp-roslyn

    # fonts
    nerd-fonts.sauce-code-pro
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    kubectl
    talosctl
    perSystem.talhelper.default
    dotnet-sdk
  ];

  modules = {
    _3d-printing.enable = true;
  };

  # enable font config
  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
