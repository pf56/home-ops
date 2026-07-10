{ inputs, lib, ... }:
{
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.stylix = {
    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.stylix.nixosModules.stylix
        ];

        stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
        };
      };

    homeManager =
      { nixosConfig, pkgs, ... }:
      {
        stylix = {
          enable = true;
          base16Scheme = nixosConfig.stylix.base16Scheme;
          image = ./wallpapers/wild.png;

          cursor = {
            name = "Nordic-cursors";
            package = pkgs.nordic;
            size = 24;
          };

          fonts = {
            serif = {
              package = pkgs.noto-fonts;
              name = "Noto Serif";
            };

            sansSerif = {
              package = pkgs.noto-fonts;
              name = "Noto Sans";
            };

            monospace = {
              package = pkgs.jetbrains-mono;
              name = "JetBrainsMono";
            };

            emoji = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };
          };

          icons = {
            enable = true;
            dark = "Nordzy";
            package = pkgs.nordzy-icon-theme;
          };

          targets.mangohud.enable = false;
          targets.librewolf.enable = false;
        };
      };
  };
}
