{ den, ... }:
{
  den.aspects.pfriedrich-cli = {
    includes = [
      den.aspects.git
      den.aspects.gpg
      den.aspects.helix
      den.aspects.ssh
      den.aspects.utilities
      den.aspects.zellij
      den.aspects.zsh
    ];
  };
}
