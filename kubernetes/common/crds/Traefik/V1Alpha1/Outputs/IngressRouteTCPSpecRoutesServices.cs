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
    /// ServiceTCP defines an upstream TCP service to proxy traffic to.
    /// </summary>
    [OutputType]
    public sealed class IngressRouteTCPSpecRoutesServices
    {
        /// <summary>
        /// Name defines the name of the referenced Kubernetes Service.
        /// </summary>
        public readonly string Name;
        /// <summary>
        /// Namespace defines the namespace of the referenced Kubernetes Service.
        /// </summary>
        public readonly string Namespace;
        /// <summary>
        /// NativeLB controls, when creating the load-balancer, whether the LB's children are directly the pods IPs or if the only child is the Kubernetes Service clusterIP. The Kubernetes Service itself does load-balance to the pods. By default, NativeLB is false.
        /// </summary>
        public readonly bool NativeLB;
        /// <summary>
        /// Port defines the port of a Kubernetes Service. This can be a reference to a named port.
        /// </summary>
        public readonly Union<int, string> Port;
        /// <summary>
        /// ProxyProtocol defines the PROXY protocol configuration. More info: https://doc.traefik.io/traefik/v2.10/routing/services/#proxy-protocol
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.IngressRouteTCPSpecRoutesServicesProxyProtocol ProxyProtocol;
        /// <summary>
        /// TerminationDelay defines the deadline that the proxy sets, after one of its connected peers indicates it has closed the writing capability of its connection, to close the reading capability as well, hence fully terminating the connection. It is a duration in milliseconds, defaulting to 100. A negative value means an infinite deadline (i.e. the reading capability is never closed).
        /// </summary>
        public readonly int TerminationDelay;
        /// <summary>
        /// Weight defines the weight used when balancing requests between multiple Kubernetes Service.
        /// </summary>
        public readonly int Weight;

        [OutputConstructor]
        private IngressRouteTCPSpecRoutesServices(
            string name,

            string @namespace,

            bool nativeLB,

            Union<int, string> port,

            Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.IngressRouteTCPSpecRoutesServicesProxyProtocol proxyProtocol,

            int terminationDelay,

            int weight)
        {
            Name = name;
            Namespace = @namespace;
            NativeLB = nativeLB;
            Port = port;
            ProxyProtocol = proxyProtocol;
            TerminationDelay = terminationDelay;
            Weight = weight;
        }
    }
}
