// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1
{

    /// <summary>
    /// ProxyProtocol defines the PROXY protocol configuration. More info: https://doc.traefik.io/traefik/v2.10/routing/services/#proxy-protocol
    /// </summary>
    public class IngressRouteTCPSpecRoutesServicesProxyProtocolArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Version defines the PROXY Protocol version to use.
        /// </summary>
        [Input("version")]
        public Input<int>? Version { get; set; }

        public IngressRouteTCPSpecRoutesServicesProxyProtocolArgs()
        {
        }
        public static new IngressRouteTCPSpecRoutesServicesProxyProtocolArgs Empty => new IngressRouteTCPSpecRoutesServicesProxyProtocolArgs();
    }
}
