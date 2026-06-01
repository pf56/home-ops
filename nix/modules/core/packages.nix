{ den, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        nft-dns = pkgs.callPackage ../../packages/nft-dns { };
      };
    };
}
