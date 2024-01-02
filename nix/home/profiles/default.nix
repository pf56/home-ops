{ inputs, ... }:

let
  hmModules = builtins.listToAttrs (map
    (x: {
      name = x;
      value = import (../modules + "/${x}");
    })
    (builtins.attrNames (builtins.readDir ../modules)));

  homeManagerConfig = [ ../. ];

  profiles = inputs: rec {
    base = [ ./base.nix ] ++ homeManagerConfig ++ (builtins.attrValues hmModules) ++ (with inputs; [
      lollypops.hmModule
    ]);

    desktop = [ ./desktop.nix ];
    pfriedrich = [ ./pfriedrich.nix ];
    "pfriedrich@base" = base ++ pfriedrich;
    "pfriedrich@home" = base ++ pfriedrich ++ desktop ++ [ ../home.nix ];
  };

  mkHomeConfig = { inputs, username, env, ... }:
    let
      env' = if env == null then "" else "@${env}";
    in
    {
      home-manager.extraSpecialArgs = with inputs; { inherit inputs; };
      home-manager.users."${username}".imports = (profiles inputs)."${username}${env'}";
    };
in
{
  "pfriedrich@home" = inputs': mkHomeConfig {
    inputs = inputs // inputs';
    username = "pfriedrich";
    env = "home";
  };

  "pfriedrich@base" = inputs': mkHomeConfig {
    inputs = inputs // inputs';
    username = "pfriedrich";
    env = "base";
  };
}
