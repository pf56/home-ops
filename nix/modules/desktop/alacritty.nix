{ ... }:
{
  den.aspects.alacritty = {
    homeManager =
      { lib, config, ... }:
      {
        programs.alacritty = {
          enable = true;
          settings = lib.mkIf (config.programs.zellij.enable or false) {
            terminal.shell = {
              program = "zellij";
              args = [
                "-l"
                "welcome"
              ];
            };
          };
        };
      };
  };
}
