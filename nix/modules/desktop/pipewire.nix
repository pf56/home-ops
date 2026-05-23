{ inputs, lib, ... }:
{
  flake-file.inputs = {
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  den.aspects.pipewire = {
    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.nix-gaming.nixosModules.pipewireLowLatency
        ];

        security.rtkit.enable = true;

        services.pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
          jack.enable = true;

          lowLatency = {
            enable = true;
          };
        };

        environment.systemPackages = with pkgs; [
          qpwgraph
        ];
      };
  };
}
