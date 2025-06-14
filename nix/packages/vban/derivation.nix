{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:

stdenv.mkDerivation rec {
  pname = "vban";
  version = "4f69e5a";

  src = fetchFromGitHub {
    owner = "quiniouben";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-V7f+jcj3NpxXNr15Ozx2is4ReeeVpl3xvelMuPNfNT0=";
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    alsa-lib
    libpulseaudio
    libjack2
  ];

  meta = with lib; {
    description = "Linux command-line VBAN tools";
    homepage = "https://github.com/quiniouben/vban";
    license = licenses.gpl3Only;
  };
}
