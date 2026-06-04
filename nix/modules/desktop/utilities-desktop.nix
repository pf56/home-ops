{ lib, ... }:
{
  den.aspects.utilities-desktop = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          evince
          grim
          mission-center
          (pass.withExtensions (ext: with ext; [ pass-otp ]))
          slurp
          wl-clipboard
          xclip
        ];

        services.xembed-sni-proxy.enable = true;
      };
  };
}
