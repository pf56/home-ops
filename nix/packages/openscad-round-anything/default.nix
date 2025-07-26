{
  perSystem,
  pkgs,
  pname,
  ...
}:

pkgs.stdenv.mkDerivation rec {
  inherit pname;
  version = "1.0.4";

  src = pkgs.fetchFromGitHub {
    owner = "Irev-Dev";
    repo = "Round-Anything";
    rev = "${version}";
    sha256 = "sha256-waCxMaLQ48DT9+u/x6AXfSM5RKQN0RAoQAU3BkaCG6k=";
  };

  installPhase = ''
    mkdir $out
    cp *.scad $out/
  '';

  meta = with pkgs.lib; {
    description = "A set of OpenSCAD utilities for adding radii and fillets, that embodies a robust approach to developing OpenSCAD parts.";
    homepage = "https://github.com/Irev-Dev/Round-Anything";
    license = licenses.mit;
  };
}
