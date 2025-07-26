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
    ./hardware-configuration.nix
    flake.nixosModules.host-base
    inputs.sops-nix.nixosModules.sops
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "git";
  networking.firewall.allowedTCPPorts = [
    80 # cgit
  ];

  environment.systemPackages = [
    pkgs.git
  ];

  users.groups.git = { };
  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/var/lib/git";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYzbuUnTGcwuYXXCve+ktgTd4HZRWCZ6j9iP0YJoS0lOMfZHxMkgLmUue/xZeeH2DkwvyVSCjlBuqhh979iVTzaLUQk6VfcryCSqST8DYtYmDPWGtEa9x64EsC1bCk78iQlILTDul11tCdAsfd9y/f4OluhdVZhPBAcoxROU5UTPc8nSrPk1+x8/x7Z0GrPvm8txx3BQyAfcQCQ/caduSu1Gd65BTcpM2FYdT6USlu4oUYvxwILuxd5VxHTpi2yyv19zp3ROx08UOylctPCr7AKnoPsUF59MrLyRmyAr1AuENY6N/NXypYA9ANrimg4ktHCc1ncWO1uMc4yhtBbUIegsZKGXhV+L7WlHKZ93PGnY08CypXH3whG4xUlSaIhuhpy/xIIDJQaKTk8Fljyb8GaD6e1C8W5efE2td4i+kEwCEaHk0/Vh3SyPNLIIW/A1d1EAtOU+kcmReS2VKJx5d/1CYwKxnuN6JyJSzODrgByeYxeaYP9ea2MG78AL5SO2ekmJuQhF6m3Df6NGmeCHKrXBsEchtobF88rATPfxMwnxrOZQYKXARYjqwU8or0qsE+C68uiQBkTFJHJAqF9Eo1QVK34A8jUYrOeY5au9cDFE01W/aY/rNl3UjmfmsvwIrXsLPbCjeq4rqT5L2K60x3gb9DZVruQB8N2vfZVecCpw==" # pfriedrich yubikey
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN0XmUGINQzn6lRxfvhjuxYYpjHFzKPzFaJZ5W8bFAiC" # pfriedrich phone
    ];
  };

  services.cgit."internal" = {
    enable = true;
    nginx.virtualHost = "git.internal.paulfriedrich.me";

    repos = {
      pass = {
        desc = "password manager (passwordstore.org)";
        path = "/var/lib/git/pass.git";
      };
    };
  };

  lollypops.deployment.local-evaluation = true;

  system.stateVersion = "23.05";
}
