{ den, ... }:
{
  den.ful.homeOps.zellij = {
    homeManager =
      { ... }:
      {
        programs.zellij = {
          enable = true;
        };
      };
  };
}
