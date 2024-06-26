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
    /// Certificate holds a secret name for the TLSStore resource.
    /// </summary>
    [OutputType]
    public sealed class TLSStoreSpecCertificates
    {
        /// <summary>
        /// SecretName is the name of the referenced Kubernetes Secret to specify the certificate details.
        /// </summary>
        public readonly string SecretName;

        [OutputConstructor]
        private TLSStoreSpecCertificates(string secretName)
        {
            SecretName = secretName;
        }
    }
}
