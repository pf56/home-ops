{ den, ... }:
{
  den.ful.homeOps.utilities = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          bat
          direnv
          htop
          unzip
        ];

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        programs.fzf.enable = true;
        programs.lsd.enable = true;
      };
  };
}
