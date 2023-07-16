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
    /// InternalTLS configures secure communication for the LINSTOR Satellite. 
    ///  If set, the control traffic between LINSTOR Controller and Satellite will be encrypted using mTLS.
    /// </summary>
    [OutputType]
    public sealed class LinstorSatelliteConfigurationSpecInternalTLS
    {
        /// <summary>
        /// CertManager references a cert-manager Issuer or ClusterIssuer. If set, a Certificate resource will be created, provisioning the secret references in SecretName using the issuer configured here.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecInternalTLSCertManager CertManager;
        /// <summary>
        /// SecretName references a secret holding the TLS key and certificates.
        /// </summary>
        public readonly string SecretName;

        [OutputConstructor]
        private LinstorSatelliteConfigurationSpecInternalTLS(
            Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecInternalTLSCertManager certManager,

            string secretName)
        {
            CertManager = certManager;
            SecretName = secretName;
        }
    }
}