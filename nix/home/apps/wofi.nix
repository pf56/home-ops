{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    wofi
  ];

  home.file = {
    ".config/wofi" = {
      source = ./wofi;
      recursive = true;
    };
  };
}
