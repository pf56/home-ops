{ config, pkgs, lib, ... }:

let
  gpgStartup = pkgs.writeShellScript "gpg4wsl" ''
        mkdir /run/user/1000/gnupg
        export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
    #    export SSH_AUTH_SOCK="/run/user/1000/gnupg/S.gpg-agent.ssh"
        if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
          rm -f "$SSH_AUTH_SOCK"
          wsl2_ssh_pageant_bin="/mnt/c/Users/pfriedrich/wsl2-ssh-pageant.exe"
          if test -x "$wsl2_ssh_pageant_bin"; then
            (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
          else
            echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
          fi
          unset wsl2_ssh_pageant_bin
        fi
        export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
    #    export GPG_AGENT_SOCK="/run/user/1000/gnupg/S.gpg-agent"
        if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
          rm -rf "$GPG_AGENT_SOCK"
          wsl2_ssh_pageant_bin="/mnt/c/Users/pfriedrich/wsl2-ssh-pageant.exe"
          config_path="C\:/Users/pfriedrich/AppData/Local/gnupg"
          if test -x "$wsl2_ssh_pageant_bin"; then
            (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin -gpgConfigBasepath ''${config_path} -gpg S.gpg-agent" >/dev/null 2>&1 &)
          else
            echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
          fi
          unset wsl2_ssh_pageant_bin
        fi
  '';
in
{
  home.username = "pfriedrich";
  home.homeDirectory = "/home/pfriedrich";
  home.packages = with pkgs; [ socat gnupg ];

  services.gpg-agent.enable = lib.mkForce false;
  services.gpg-agent.enableSshSupport = lib.mkForce false;

  #programs.git.signing.gpgPath = "/mnt/c/Program Files (x86)/GnuPG/bin/gpg.exe";
  programs.zsh.initExtra = "source ${gpgStartup}";

  home.stateVersion = "23.05";
}
