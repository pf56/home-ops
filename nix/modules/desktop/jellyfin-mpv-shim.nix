{ ... }:
{
  den.aspects.jellyfin-mpv-shim = {
    homeManager = {
      services.jellyfin-mpv-shim = {
        enable = true;
      };
    };
  };
}
