{ config, pkgs, libs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableUpdateCheck = false;

    userSettings = {
      "editor.fontFamily" = "'SauceCodePro Nerd Font', 'monospace', monospace";
      "workbench.tree.expandMode" = "doubleClick";
    };

    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      eamodio.gitlens
      pkgs.vscode-cust-extensions.hashicorp.hcl
    ];
  };
}
