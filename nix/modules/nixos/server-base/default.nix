{
  config,
  pkgs,
  lib,
  inputs,
  flake,
  ...
}:

{
  imports = [
    flake.nixosModules.lollypops-base
  ];

  boot.growPartition = true;

  # add users
  users.users.pfriedrich = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYzbuUnTGcwuYXXCve+ktgTd4HZRWCZ6j9iP0YJoS0lOMfZHxMkgLmUue/xZeeH2DkwvyVSCjlBuqhh979iVTzaLUQk6VfcryCSqST8DYtYmDPWGtEa9x64EsC1bCk78iQlILTDul11tCdAsfd9y/f4OluhdVZhPBAcoxROU5UTPc8nSrPk1+x8/x7Z0GrPvm8txx3BQyAfcQCQ/caduSu1Gd65BTcpM2FYdT6USlu4oUYvxwILuxd5VxHTpi2yyv19zp3ROx08UOylctPCr7AKnoPsUF59MrLyRmyAr1AuENY6N/NXypYA9ANrimg4ktHCc1ncWO1uMc4yhtBbUIegsZKGXhV+L7WlHKZ93PGnY08CypXH3whG4xUlSaIhuhpy/xIIDJQaKTk8Fljyb8GaD6e1C8W5efE2td4i+kEwCEaHk0/Vh3SyPNLIIW/A1d1EAtOU+kcmReS2VKJx5d/1CYwKxnuN6JyJSzODrgByeYxeaYP9ea2MG78AL5SO2ekmJuQhF6m3Df6NGmeCHKrXBsEchtobF88rATPfxMwnxrOZQYKXARYjqwU8or0qsE+C68uiQBkTFJHJAqF9Eo1QVK34A8jUYrOeY5au9cDFE01W/aY/rNl3UjmfmsvwIrXsLPbCjeq4rqT5L2K60x3gb9DZVruQB8N2vfZVecCpw=="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHBJYfcGa9cjmJ8SMMqdOny0Bs/4t+pGBXnLk1Pkp+u openpgp:0x77E621AF"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3CkovLNkyQNHJIKGfOKDj0Jn6sE0O53qSUw4XOU3U4 pfriedrich@e595"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # enable OpenSSH
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall = {
    enable = lib.mkDefault true;
  };

  sops = {
    defaultSopsFile = ../../../secrets/${config.networking.hostName}.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  nix = {
    # trust packages built on a different machine
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;

      substituters = [ "https://ghostty.cachix.org" ];
      trusted-public-keys = [
        "pizza.internal.paulfriedrich.me:/8ZeJy7jCNTZtVq0a/by4XTGVp7QZS9nPzfDeJ+TvIA="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
