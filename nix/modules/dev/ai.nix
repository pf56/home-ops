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
          "ai/kubernetes-token" = {
            owner = "pfriedrich";
            mode = "0400";
          };
          "ai/kubernetes-ca" = {
            owner = "pfriedrich";
            mode = "0400";
          };
        };
      };

    homeManager =
      { osConfig, pkgs, ... }:
      let
        kubernetesExecCredential = pkgs.writeShellApplication {
          name = "opencode-kubernetes-credential";
          text = ''
            if [ -z "''${KUBERNETES_BEARER_TOKEN:-}" ]; then
              echo "KUBERNETES_BEARER_TOKEN is not available" >&2
              exit 1
            fi

            printf '%s\n' '{"apiVersion":"client.authentication.k8s.io/v1","kind":"ExecCredential","status":{"token":"'"$KUBERNETES_BEARER_TOKEN"'"}}'
          '';
        };
      in
      {
        home.packages = with pkgs; [
          openspec
          nono
          kubectl
        ];

        programs.opencode = {
          enable = true;
          enableMcpIntegration = true;
        };

        xdg.configFile = {
          "kubernetes/opencode-kubeconfig".text = builtins.toJSON {
            apiVersion = "v1";
            kind = "Config";
            clusters = [
              {
                name = "homelab";
                cluster.server = "https://kube.internal.paulfriedrich.me:6443";
              }
            ];
            contexts = [
              {
                name = "opencode@homelab";
                context = {
                  cluster = "homelab";
                  user = "opencode";
                };
              }
            ];
            current-context = "opencode@homelab";
            users = [
              {
                name = "opencode";
                user.exec = {
                  apiVersion = "client.authentication.k8s.io/v1";
                  command = lib.getExe kubernetesExecCredential;
                  interactiveMode = "Never";
                };
              }
            ];
          };

          "nono/profiles/opencode-homelab.json".text = builtins.toJSON {
            extends = "opencode";
            meta = {
              name = "opencode-homelab";
            };
            filesystem = {
              read = [ "/run/secrets/ai/grafana-mcp-token" ];
              read_file = [ "$HOME/.config/kubernetes/opencode-kubeconfig" ];
            };
            network = {
              credentials = [ "kubernetes" ];
              custom_credentials.kubernetes = {
                upstream = "https://kube.internal.paulfriedrich.me:6443";
                credential_key = "file://${osConfig.sops.secrets."ai/kubernetes-token".path}";
                env_var = "KUBERNETES_BEARER_TOKEN";
                inject_header = "Authorization";
                credential_format = "Bearer {}";
                endpoint_rules = [
                  {
                    method = "GET";
                    path = "/**";
                  }
                ];
                # The cluster CA is supervisor-only and is not a sandbox filesystem grant.
                tls_ca = osConfig.sops.secrets."ai/kubernetes-ca".path;
              };
            };
            environment.set_vars.KUBECONFIG = "$HOME/.config/kubernetes/opencode-kubeconfig";
          };
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
