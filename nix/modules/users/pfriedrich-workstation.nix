{ den, ... }:
{
  den.aspects.pfriedrich-workstation = {
    includes = [
      den.aspects."3d-printing"
      den.aspects.alacritty
      den.aspects.wofi

      den.aspects.bongocat
      den.aspects.desktop-base
      den.aspects.fuzzel
      den.aspects.jellyfin-mpv-shim
      den.aspects.librewolf
      den.aspects.thunar
      den.aspects.utilities-desktop
      den.aspects.wpaperd

      den.aspects.kubernetes
      den.aspects.dotnet
      den.aspects.fonts
      den.aspects.ai
      (den.aspects.vim { full = true; })
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          bcompare
          (discord.override (old: rec {
            withVencord = true;
          }))
          discover-overlay
          firefox
          opentofu
          sops
          terminator
          thunderbird
          trash-cli
          yubikey-manager
          yubikey-touch-detector

          # language servers
          yaml-language-server
        ];
      };
  };
}
