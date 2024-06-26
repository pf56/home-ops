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
    /// Info selects the specific client certificate details you want to add to the X-Forwarded-Tls-Client-Cert-Info header.
    /// </summary>
    public class MiddlewareSpecPassTLSClientCertInfoArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Issuer defines the client certificate issuer details to add to the X-Forwarded-Tls-Client-Cert-Info header.
        /// </summary>
        [Input("issuer")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.MiddlewareSpecPassTLSClientCertInfoIssuerArgs>? Issuer { get; set; }

        /// <summary>
        /// NotAfter defines whether to add the Not After information from the Validity part.
        /// </summary>
        [Input("notAfter")]
        public Input<bool>? NotAfter { get; set; }

        /// <summary>
        /// NotBefore defines whether to add the Not Before information from the Validity part.
        /// </summary>
        [Input("notBefore")]
        public Input<bool>? NotBefore { get; set; }

        /// <summary>
        /// Sans defines whether to add the Subject Alternative Name information from the Subject Alternative Name part.
        /// </summary>
        [Input("sans")]
        public Input<bool>? Sans { get; set; }

        /// <summary>
        /// SerialNumber defines whether to add the client serialNumber information.
        /// </summary>
        [Input("serialNumber")]
        public Input<bool>? SerialNumber { get; set; }

        /// <summary>
        /// Subject defines the client certificate subject details to add to the X-Forwarded-Tls-Client-Cert-Info header.
        /// </summary>
        [Input("subject")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.MiddlewareSpecPassTLSClientCertInfoSubjectArgs>? Subject { get; set; }

        public MiddlewareSpecPassTLSClientCertInfoArgs()
        {
        }
        public static new MiddlewareSpecPassTLSClientCertInfoArgs Empty => new MiddlewareSpecPassTLSClientCertInfoArgs();
    }
}
