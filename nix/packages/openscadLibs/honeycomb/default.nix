{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation rec {
  pname = "honeycomb-openscad";
  version = "dd1480b";

  src = fetchFromGitHub {
    owner = "smkent";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-D+hx3GZvIdsc1tXORP69Nk7l/dNI9Tb0CM8xS7BtCtQ=";
  };

  installPhase = ''
    mkdir $out
    cp honeycomb.scad $out/
  '';

  meta = with lib; {
    description = "Honeycomb library for OpenSCAD, based on Gael Lafond's library https://printables.com/model/263718";
    homepage = "https://github.com/smkent/honeycomb-openscad";
    license = licenses.cc-by-40;
  };
}
