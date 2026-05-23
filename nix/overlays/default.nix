{ ... }:
{
  custom-packages = final: prev: {
    openscad-honeycomb = final.callPackage ../packages/openscad-honeycomb { };
    openscad-libs = final.callPackage ../packages/openscad-libs { };
    openscad-round-anything = final.callPackage ../packages/openscad-round-anything { };
    tailscale-cgnat = final.callPackage ../packages/tailscale-cgnat { };
  };
}
