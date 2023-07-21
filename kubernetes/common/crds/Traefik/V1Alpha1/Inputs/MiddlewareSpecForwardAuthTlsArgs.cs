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
    /// TLS defines the configuration used to secure the connection to the authentication server.
    /// </summary>
    public class MiddlewareSpecForwardAuthTlsArgs : global::Pulumi.ResourceArgs
    {
        [Input("caOptional")]
        public Input<bool>? CaOptional { get; set; }

        /// <summary>
        /// CASecret is the name of the referenced Kubernetes Secret containing the CA to validate the server certificate. The CA certificate is extracted from key `tls.ca` or `ca.crt`.
        /// </summary>
        [Input("caSecret")]
        public Input<string>? CaSecret { get; set; }

        /// <summary>
        /// CertSecret is the name of the referenced Kubernetes Secret containing the client certificate. The client certificate is extracted from the keys `tls.crt` and `tls.key`.
        /// </summary>
        [Input("certSecret")]
        public Input<string>? CertSecret { get; set; }

        /// <summary>
        /// InsecureSkipVerify defines whether the server certificates should be validated.
        /// </summary>
        [Input("insecureSkipVerify")]
        public Input<bool>? InsecureSkipVerify { get; set; }

        public MiddlewareSpecForwardAuthTlsArgs()
        {
        }
        public static new MiddlewareSpecForwardAuthTlsArgs Empty => new MiddlewareSpecForwardAuthTlsArgs();
    }
}
