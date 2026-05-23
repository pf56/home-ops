{ ... }:
{
  custom-packages = final: prev: {
    openscad-honeycomb = final.callPackage ../packages/openscad-honeycomb { };
    openscad-libs = final.callPackage ../packages/openscad-libs { };
    openscad-round-anything = final.callPackage ../packages/openscad-round-anything { };
    tailscale-cgnat = final.callPackage ../packages/tailscale-cgnat { };
    yubikey-touch-detector = prev.yubikey-touch-detector.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "max-baz";
        repo = "yubikey-touch-detector";
        rev = "c469dcc76cddb0ab5fc401550b5dd6d178fa3336";
        hash = "sha256-AU7ajLcQ1mlnE3rXR7hGV7RD0N6gt75LMh/4UxXyfvo=";
      };
      vendorHash = "sha256-SRLhlR8qFx+cvJtWXfInE6xm/RfV4A/zfZK20esLbro=";
    });
  };
}
