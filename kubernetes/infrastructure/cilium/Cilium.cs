using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using Microsoft.AspNetCore.Localization;
using Pulumi;
using Pulumi.Kubernetes.ApiExtensions;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Yaml;
using CustomResource = Pulumi.Kubernetes.ApiExtensions.CustomResource;

namespace Cilium;

public class Cilium : Stack
{
    private const string repo = "https://helm.cilium.io/";
    private const string version = "1.13.4";

    public Cilium()
    {
        Namespace @namespace = new("namespace", new NamespaceArgs
        {
            ApiVersion = "v1",
            Kind = "Namespace",
            Metadata = new ObjectMetaArgs
            {
                Name = "cilium",
                Labels =
                {
                    { "pod-security.kubernetes.io/enforce", "privileged" },
                    { "pod-security.kubernetes.io/audit", "privileged" },
                    { "pod-security.kubernetes.io/warn", "privileged" }
                }
            }
        });

        Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);

        Release cilium = new("cilium", new ReleaseArgs
        {
            Chart = "cilium",
            Version = version,
            Namespace = namespaceName,
            RepositoryOpts = new RepositoryOptsArgs
            {
                Repo = repo
            },
            Values = new InputMap<object>
            {
                ["ipam"] = new InputMap<object>
                {
                    ["mode"] = "kubernetes"
                },
                ["kubeProxyReplacement"] = "strict",
                ["securityContext"] = new InputMap<object>
                {
                    ["capabilities"] = new InputMap<object>
                    {
                        ["ciliumAgent"] = new InputList<string>
                        {
                            "CHOWN",
                            "KILL",
                            "NET_ADMIN",
                            "NET_RAW",
                            "IPC_LOCK",
                            "SYS_ADMIN",
                            "SYS_RESOURCE",
                            "DAC_OVERRIDE",
                            "FOWNER",
                            "SETGID",
                            "SETUID"
                        },
                        ["cleanCiliumState"] = new InputList<string>
                        {
                            "NET_ADMIN",
                            "SYS_ADMIN",
                            "SYS_RESOURCE"
                        }
                    }
                },
                ["cgroup"] = new InputMap<object>
                {
                    ["autoMount"] = new InputMap<object>
                    {
                        ["enabled"] = false
                    },
                    ["hostRoot"] = "/sys/fs/cgroup"
                },
                ["k8sServiceHost"] = "10.0.60.5",
                ["k8sServicePort"] = "6443",
                ["bgpControlPlane"] = new InputMap<object>
                {
                    ["enabled"] = true
                },
                ["egressGateway"] = new InputMap<object>
                {
                    ["enabled"] = true
                },
                ["bpf"] = new InputMap<object>
                {
                    ["masquerade"] = true
                },
                ["MTU"] = 1360
            }
        });

        var bgpPeeringPolicy = new ConfigFile("bgp-peering-policy", new ConfigFileArgs
        {
            File = "./Manifests/CiliumBGPPeeringPolicy.yaml"
        });

        var bgpAddressPool = new ConfigFile("bgp-address-pool", new ConfigFileArgs
        {
            File = "./Manifests/CiliumLoadBalancerIPPool.yaml"
        });

        // var egressGateway = new ConfigFile("egress-gateway", new ConfigFileArgs
        // {
        //     File = "./Manifests/CiliumEgressGatewayPolicy.yaml"
        // });
    }
}
