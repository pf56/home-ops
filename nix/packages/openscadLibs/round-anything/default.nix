{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "round-anything";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "Irev-Dev";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-waCxMaLQ48DT9+u/x6AXfSM5RKQN0RAoQAU3BkaCG6k=";
  };

  installPhase = ''
    mkdir $out
    cp *.scad $out/
  '';

  meta = with lib; {
    description = "A set of OpenSCAD utilities for adding radii and fillets, that embodies a robust approach to developing OpenSCAD parts.";
    homepage = "https://github.com/Irev-Dev/Round-Anything";
    license = licenses.mit;
  };
}
