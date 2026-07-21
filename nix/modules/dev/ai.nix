{ lib, ... }:
{
  den.aspects.ai = {
    nixos =
      { user, ... }:
      {
        users.groups.grafana-mcp = { };
        users.users.${user.userName}.extraGroups = [ "grafana-mcp" ];

        sops.secrets = {
          "ai/grafana-mcp-token" = {
            owner = "pfriedrich";
            group = "grafana-mcp";
            mode = "0440";
          };
        };
      };

    homeManager =
      { osConfig, pkgs, ... }:
      {
        home.packages = with pkgs; [ ];

        programs.opencode = {
          enable = true;
          enableMcpIntegration = true;
        };

        programs.mcp = {
          enable = true;
          servers = {
            grafana = {
              command = "${lib.getExe pkgs.mcp-grafana}";
              env = {
                GRAFANA_URL = "https://dashboard.internal.paulfriedrich.me";
                GRAFANA_SERVICE_ACCOUNT_TOKEN.file = osConfig.sops.secrets."ai/grafana-mcp-token".path;
              };
            };
          };
        };

        xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
          autoupdate = false;
          share = "disabled";
        };
      };
  };
}
