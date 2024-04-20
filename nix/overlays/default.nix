final: prev: {
  hyprland-workspaces = prev.callPackage ../packages/hyprland-workspaces { };
  openscadLibs.honeycomb = prev.callPackage ../packages/openscadLibs/honeycomb { };
  openscadLibs.round-anything = prev.callPackage ../packages/openscadLibs/round-anything { };
  vban = prev.callPackage ../packages/vban { };
}
