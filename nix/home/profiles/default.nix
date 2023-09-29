{ inputs, ... }:
let
  homeManagerConfig = [ ../. ];
  profiles = rec {
    base = [ ./base.nix ] ++ homeManagerConfig;
    desktop = base ++ [ ./desktop.nix ];
    pfriedrich = base ++ [ ./pfriedrich.nix ];
    "pfriedrich@home" = pfriedrich ++ desktop ++ [ ../home.nix ];
    "pfriedrich@work-wsl" = pfriedrich ++ [ ../work-wsl.nix ];
  };
in
{
  imports = [
    { _module.args = { inherit profiles; }; }
  ];
}
