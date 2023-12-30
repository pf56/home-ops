{ lib, rustPlatform, fetchFromGitHub, ... }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-workspaces";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "FieldofClay";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5/add1VSJe5ChKi4UU5iUKRAj4kMjOnbB76QX/FkA6k=";
  };

  cargoSha256 = "sha256-kUDo+6fsrzzojHYNMNBYpztGJPPtPp/OXUypUJnzebY=";

  meta = with lib; {
    description = "A multi-monitor aware Hyprland workspace widget ";
    homepage = "https://github.com/FieldofClay/hyprland-workspaces";
    license = licenses.unlicense;
  };
}
