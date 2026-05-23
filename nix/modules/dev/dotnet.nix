{ lib, ... }:
{
  den.aspects.dotnet = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          dotnet-sdk
          jetbrains.rider
          omnisharp-roslyn
        ];
      };
  };
}
