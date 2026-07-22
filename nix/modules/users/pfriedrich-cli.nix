{ den, ... }:
{
  den.ful.homeOps.pfriedrich-cli = {
    includes = [
      den.ful.homeOps.git
      den.ful.homeOps.gpg
      den.ful.homeOps.helix
      den.ful.homeOps.ssh
      den.ful.homeOps.utilities
      den.ful.homeOps.zellij
      den.ful.homeOps.zsh
    ];
  };
}
