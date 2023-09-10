{ inputs, ... }:
let
  homeManagerConfig = [ ../. ];
  profiles = {
    "pfriedrich" = [ ../home.nix ] ++ homeManagerConfig;
  };
in
{
  imports = [
    { _module.args = { inherit profiles; }; }
  ];
}
