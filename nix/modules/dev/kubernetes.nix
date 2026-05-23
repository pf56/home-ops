{ lib, ... }:
{
  den.aspects.kubernetes = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          argocd
          k9s
          kubectl
          kubernetes-helm
          talosctl
          talhelper
        ];
      };
  };
}
