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

  mkHomeConfig = { home-manager, username, env, ... }: 
  let
    env' = if env == null then "" else "@${env}";
  in {
    home-manager.extraSpecialArgs = with inputs; { inherit lollypops; inherit talhelper; };
    home-manager.users."${username}".imports = profiles."${username}${env'}";
  };
in
{
  "pfriedrich@home" = { home-manager, ... }: mkHomeConfig {
    inherit home-manager;
    username = "pfriedrich";
    env = "home";
  };

  "pfriedrich@work" = { home-manager, ... }: mkHomeConfig {
    inherit home-manager;
    username = "pfriedrich";
    env = null;
  };
}
