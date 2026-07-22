{ den, ... }:
{
  den.ful.homeOps.zsh = {
    nixos =
      { pkgs, ... }:
      {
      };

    homeManager =
      { pkgs, config, ... }:
      {
        home.shell.enableZshIntegration = true;

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

          initContent = ''
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

            argocd-local-diff() {
              if (( $# < 1 )); then
                print -u2 "usage: argocd-local-diff <application> [argocd diff flags]"
                return 2
              fi

              local app="$1"
              local directory_name="''${PWD##*/}"
              local repo_root
              shift

              if [[ "$directory_name" != "$app" ]]; then
                print -u2 "refusing to diff application \"$app\" from \"$PWD\""
                return 2
              fi

              repo_root="$(git rev-parse --show-toplevel)" || return

              argocd app diff "$app" \
                --local "$PWD" \
                --local-repo-root "$repo_root" \
                --server-side-generate \
                "$@"
            }

            argocd-local-sync() {
              if (( $# < 1 )); then
                print -u2 "usage: argocd-local-sync <application> [argocd sync flags]"
                return 2
              fi

              local app="$1"
              local directory_name="''${PWD##*/}"
              local repo_root
              shift

              if [[ "$directory_name" != "$app" ]]; then
                print -u2 "refusing to sync application \"$app\" from \"$PWD\""
                return 2
              fi

              repo_root="$(git rev-parse --show-toplevel)" || return

              argocd app sync "$app" \
                --local "$PWD" \
                --local-repo-root "$repo_root" \
                "$@"
            }
          '';

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

      };
  };
}
