{
  perSystem,
  pkgs,
  pname,
  flake,
  ...
}:
pkgs.tailscale.overrideAttrs (prev: {
  patches = (prev.patches or [ ]) ++ [ ./tailscale-cgnat.patch ];
  doCheck = false;
})
