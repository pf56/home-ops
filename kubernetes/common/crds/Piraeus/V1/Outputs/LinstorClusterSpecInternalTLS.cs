// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.Piraeus.V1
{

    /// <summary>
    /// InternalTLS secures the connection between LINSTOR Controller and Satellite. 
    ///  This configures the client certificate used when the Controller connects to a Satellite. This only has an effect when the Satellite is configured to for secure connections using `LinstorSatellite.spec.internalTLS`.
    /// </summary>
    [OutputType]
    public sealed class LinstorClusterSpecInternalTLS
    {
        /// <summary>
        /// CertManager references a cert-manager Issuer or ClusterIssuer. If set, a Certificate resource will be created, provisioning the secret references in SecretName using the issuer configured here.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorClusterSpecInternalTLSCertManager CertManager;
        /// <summary>
        /// SecretName references a secret holding the TLS key and certificates.
        /// </summary>
        public readonly string SecretName;

        [OutputConstructor]
        private LinstorClusterSpecInternalTLS(
            Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorClusterSpecInternalTLSCertManager certManager,

            string secretName)
        {
            CertManager = certManager;
            SecretName = secretName;
        }
    }
}
