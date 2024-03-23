{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;

    autosuggestion = {
      enable = true;
    };

    history = {
      ignoreSpace = true;
      size = 1000000;
    };

    shellAliases = {
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls --tree";
    } // lib.optionalAttrs (config.programs.lsd.enable) { ls = "lsd"; };

    initExtra = lib.concatLines ([
      ''
        # highlight the selected entry
        zstyle ':completion:*' menu select
        zmodload zsh/complist

        # shift+tab through suggestions
        bindkey -M menuselect '^[[Z' reverse-menu-complete

        # search through history
        bindkey $terminfo[kcuu1] history-beginning-search-backward
        bindkey $terminfo[kcud1] history-beginning-search-forward

        # ctrl+left/right
        bindkey $terminfo[kLFT5] backward-word
        bindkey $terminfo[kRIT5] forward-word
      ''
    ] ++ lib.optional (lib.elem pkgs.direnv config.home.packages) "eval \"$(direnv hook zsh)\"");

    plugins = [
      {
        name = "forgit";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "3f00348d5c712e1a0013bf64a08dd2ce8c8539e3";
          sha256 = "1x9pak8hqmd4k1771yyc4n0x89q3l5p4102n8810s9zfxhidhnyy";
        };
      }
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
