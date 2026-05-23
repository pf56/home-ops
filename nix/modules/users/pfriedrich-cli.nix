{ den, ... }:
{
  den.aspects.pfriedrich-cli = {
    includes = [
      den.aspects.git
      den.aspects.gpg
      den.aspects.ssh
      den.aspects.utilities
      den.aspects.zsh

      den.aspects.helix
    ];
  };
}
