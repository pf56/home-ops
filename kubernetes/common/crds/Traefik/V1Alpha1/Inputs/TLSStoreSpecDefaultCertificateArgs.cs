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
    /// DefaultCertificate defines the default certificate configuration.
    /// </summary>
    public class TLSStoreSpecDefaultCertificateArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// SecretName is the name of the referenced Kubernetes Secret to specify the certificate details.
        /// </summary>
        [Input("secretName", required: true)]
        public Input<string> SecretName { get; set; } = null!;

        public TLSStoreSpecDefaultCertificateArgs()
        {
        }
        public static new TLSStoreSpecDefaultCertificateArgs Empty => new TLSStoreSpecDefaultCertificateArgs();
    }
}
