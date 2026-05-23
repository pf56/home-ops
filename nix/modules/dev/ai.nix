{ lib, ... }:
{
  den.aspects.ai = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          opencode
        ];

        xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
          "$schema" = "https://opencode.ai/config.json";
          autoupdate = false;
          share = "disabled";
        };
      };
  };
}
