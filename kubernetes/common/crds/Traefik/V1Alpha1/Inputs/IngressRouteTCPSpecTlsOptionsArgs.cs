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
    /// Options defines the reference to a TLSOption, that specifies the parameters of the TLS connection. If not defined, the `default` TLSOption is used. More info: https://doc.traefik.io/traefik/v2.10/https/tls/#tls-options
    /// </summary>
    public class IngressRouteTCPSpecTlsOptionsArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Name defines the name of the referenced Traefik resource.
        /// </summary>
        [Input("name", required: true)]
        public Input<string> Name { get; set; } = null!;

        /// <summary>
        /// Namespace defines the namespace of the referenced Traefik resource.
        /// </summary>
        [Input("namespace")]
        public Input<string>? Namespace { get; set; }

        public IngressRouteTCPSpecTlsOptionsArgs()
        {
        }
        public static new IngressRouteTCPSpecTlsOptionsArgs Empty => new IngressRouteTCPSpecTlsOptionsArgs();
    }
}
