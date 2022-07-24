{ config, pkgs, lib, ...  }:

{
  programs.zsh = {
    enable = true;

    initExtra = ''
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
    '';

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosugestions";
          rev = "v0.7.0";
          sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
        };
      }

      {
        name = "forgit";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "bd8fce74a662fd6ed90d942a797531ffd0492ae8";
          sha256 = "1kkq0xs87vrwanxqwypfh8mkjvjplv8s9igcxvygznhhgrnnh2pl";
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
