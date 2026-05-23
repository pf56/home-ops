{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nh
        ];

        shellHook = ''
          export NH_FLAKE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
        '';
      };
    };
}
