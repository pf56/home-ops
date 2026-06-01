{
  lib,
  fetchgit,
  pandoc,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "nft-dns";
  version = "0.6.1";

  format = "other";

  src = fetchgit {
    url = "https://git.azlux.fr/Azlux/nft-dns.git";
    rev = "083fb2bd4b24f17f4c10b4726550a8a6eb9bfd16";
    hash = "sha256-0UHENhLEOnflUhCZSfQv5yGI0Yt4u4Q6YG6ZLT5H7ow=";
  };

  nativeBuildInputs = [
    pandoc
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dnspython
    pydantic_1
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 MANUAL.md "$out/share/doc/${finalAttrs.pname}/MANUAL.md"
    install -Dm644 README.md "$out/share/doc/${finalAttrs.pname}/README.md"
    install -Dm644 nft-dns.conf "$out/share/doc/${finalAttrs.pname}/nft-dns.conf.example"

    install -Dm644 entry.py "$out/${python3.sitePackages}/entry.py"
    install -Dm755 nft-dns.py "$out/bin/nft-dns"
    ln -s nft-dns "$out/bin/nft-dns.py"

    pandoc --standalone --to man MANUAL.md --output nft-dns.1
    install -Dm644 nft-dns.1 "$out/share/man/man1/nft-dns.1"

    runHook postInstall
  '';

  meta = {
    description = "Resolve FQDNs into nftables sets and keep them refreshed";
    homepage = "https://git.azlux.fr/Azlux/nft-dns";
    changelog = "https://git.azlux.fr/Azlux/nft-dns";
    license = lib.licenses.mit;
    mainProgram = "nft-dns";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
