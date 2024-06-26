// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1
{

    /// <summary>
    /// Mirroring defines the Mirroring service configuration.
    /// </summary>
    [OutputType]
    public sealed class TraefikServiceSpecMirroring
    {
        /// <summary>
        /// Kind defines the kind of the Service.
        /// </summary>
        public readonly string Kind;
        /// <summary>
        /// MaxBodySize defines the maximum size allowed for the body of the request. If the body is larger, the request is not mirrored. Default value is -1, which means unlimited size.
        /// </summary>
        public readonly int MaxBodySize;
        /// <summary>
        /// Mirrors defines the list of mirrors where Traefik will duplicate the traffic.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TraefikServiceSpecMirroringMirrors> Mirrors;
        /// <summary>
        /// Name defines the name of the referenced Kubernetes Service or TraefikService. The differentiation between the two is specified in the Kind field.
        /// </summary>
        public readonly string Name;
        /// <summary>
        /// Namespace defines the namespace of the referenced Kubernetes Service or TraefikService.
        /// </summary>
        public readonly string Namespace;
        /// <summary>
        /// NativeLB controls, when creating the load-balancer, whether the LB's children are directly the pods IPs or if the only child is the Kubernetes Service clusterIP. The Kubernetes Service itself does load-balance to the pods. By default, NativeLB is false.
        /// </summary>
        public readonly bool NativeLB;
        /// <summary>
        /// PassHostHeader defines whether the client Host header is forwarded to the upstream Kubernetes Service. By default, passHostHeader is true.
        /// </summary>
        public readonly bool PassHostHeader;
        /// <summary>
        /// Port defines the port of a Kubernetes Service. This can be a reference to a named port.
        /// </summary>
        public readonly Union<int, string> Port;
        /// <summary>
        /// ResponseForwarding defines how Traefik forwards the response from the upstream Kubernetes Service to the client.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TraefikServiceSpecMirroringResponseForwarding ResponseForwarding;
        /// <summary>
        /// Scheme defines the scheme to use for the request to the upstream Kubernetes Service. It defaults to https when Kubernetes Service port is 443, http otherwise.
        /// </summary>
        public readonly string Scheme;
        /// <summary>
        /// ServersTransport defines the name of ServersTransport resource to use. It allows to configure the transport between Traefik and your servers. Can only be used on a Kubernetes Service.
        /// </summary>
        public readonly string ServersTransport;
        /// <summary>
        /// Sticky defines the sticky sessions configuration. More info: https://doc.traefik.io/traefik/v2.10/routing/services/#sticky-sessions
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TraefikServiceSpecMirroringSticky Sticky;
        /// <summary>
        /// Strategy defines the load balancing strategy between the servers. RoundRobin is the only supported value at the moment.
        /// </summary>
        public readonly string Strategy;
        /// <summary>
        /// Weight defines the weight and should only be specified when Name references a TraefikService object (and to be precise, one that embeds a Weighted Round Robin).
        /// </summary>
        public readonly int Weight;

        [OutputConstructor]
        private TraefikServiceSpecMirroring(
            string kind,

            int maxBodySize,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TraefikServiceSpecMirroringMirrors> mirrors,

            string name,

            string @namespace,

            bool nativeLB,

            bool passHostHeader,

            Union<int, string> port,

            Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TraefikServiceSpecMirroringResponseForwarding responseForwarding,

            string scheme,

            string serversTransport,

            Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TraefikServiceSpecMirroringSticky sticky,

            string strategy,

            int weight)
        {
            Kind = kind;
            MaxBodySize = maxBodySize;
            Mirrors = mirrors;
            Name = name;
            Namespace = @namespace;
            NativeLB = nativeLB;
            PassHostHeader = passHostHeader;
            Port = port;
            ResponseForwarding = responseForwarding;
            Scheme = scheme;
            ServersTransport = serversTransport;
            Sticky = sticky;
            Strategy = strategy;
            Weight = weight;
        }
    }
}
