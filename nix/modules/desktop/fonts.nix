{ lib, ... }:
{
  den.aspects.fonts = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          nerd-fonts.sauce-code-pro
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
        ];

        fonts.fontconfig.enable = true;
      };
  };
}
