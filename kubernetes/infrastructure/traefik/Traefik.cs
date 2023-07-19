using Pulumi;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;

namespace Traefik;

public class Traefik : Stack
{
    private const string repo = "https://traefik.github.io/charts/";
    private const string version = "23.1.0";

    public Traefik()
    {
        Namespace @namespace = new("namespace", new NamespaceArgs
        {
            ApiVersion = "v1",
            Kind = "Namespace",
            Metadata = new ObjectMetaArgs
            {
                Name = "traefik"
            }
        });

        var namespaceName = @namespace.Metadata.Apply(x => x.Name);

        Release traefikIngress = new("traefik-ingress", new ReleaseArgs
        {
            Chart = "traefik",
            Version = version,
            Namespace = namespaceName,
            RepositoryOpts = new RepositoryOptsArgs
            {
                Repo = repo
            },
            Values = new InputMap<object>
            {
                ["service"] = new InputMap<object>
                {
                    ["annotations"] = new InputMap<object>
                    {
                        ["io.cilium/lb-ipam-ips"] = "172.16.61.1"
                    }
                }
            }
        });
    }
}