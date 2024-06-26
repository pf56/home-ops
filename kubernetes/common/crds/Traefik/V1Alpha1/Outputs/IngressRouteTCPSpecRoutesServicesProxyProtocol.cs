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
    /// ProxyProtocol defines the PROXY protocol configuration. More info: https://doc.traefik.io/traefik/v2.10/routing/services/#proxy-protocol
    /// </summary>
    [OutputType]
    public sealed class IngressRouteTCPSpecRoutesServicesProxyProtocol
    {
        /// <summary>
        /// Version defines the PROXY Protocol version to use.
        /// </summary>
        public readonly int Version;

        [OutputConstructor]
        private IngressRouteTCPSpecRoutesServicesProxyProtocol(int version)
        {
            Version = version;
        }
    }
}
