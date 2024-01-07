{ lib, python3Packages }:

with python3Packages;
buildPythonApplication {
  pname = "yubikey-touch-connector";
  version = "1.0";

  src = ./.;
}
