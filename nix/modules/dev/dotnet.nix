{ lib, ... }:
{
  den.aspects.dotnet = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          dotnet-sdk_10
          jetbrains-toolbox
          omnisharp-roslyn
        ];

        xdg.configFile."environment.d/dotnet.conf".text = ''
          SSL_CERT_DIR=/etc/ssl/certs:/home/pfriedrich/.aspnet/dev-certs/trust
        '';
      };
  };
}
