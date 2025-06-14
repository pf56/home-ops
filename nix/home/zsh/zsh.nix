{
  config,
  pkgs,
  lib,
  ...
}:

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
    };

    initContent = lib.concatLines (
      [
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
      ]
      ++ lib.optional (lib.elem pkgs.direnv config.home.packages) "eval \"$(direnv hook zsh)\""
    );

    plugins = [
      {
        name = "forgit";
        src = "${pkgs.zsh-forgit}";
        file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
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
