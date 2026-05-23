{ ... }:
{
  den.aspects.vim =
    {
      full ? false,
      ...
    }:
    {
      homeManager =
        { pkgs, ... }:
        {
          home.packages = [ (if full then pkgs.vim-full else pkgs.vim) ];
        };
    };
}
