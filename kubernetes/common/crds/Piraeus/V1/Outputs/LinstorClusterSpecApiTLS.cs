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
    /// ApiTLS secures the LINSTOR API. 
    ///  This configures the TLS key and certificate used to secure the LINSTOR API.
    /// </summary>
    [OutputType]
    public sealed class LinstorClusterSpecApiTLS
    {
        /// <summary>
        /// ApiSecretName references a secret holding the TLS key and certificate used to protect the API. Defaults to "linstor-api-tls".
        /// </summary>
        public readonly string ApiSecretName;
        /// <summary>
        /// CertManager references a cert-manager Issuer or ClusterIssuer. If set, cert-manager.io/Certificate resources will be created, provisioning the secrets referenced in *SecretName using the issuer configured here.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorClusterSpecApiTLSCertManager CertManager;
        /// <summary>
        /// ClientSecretName references a secret holding the TLS key and certificate used by the operator to configure the cluster. Defaults to "linstor-client-tls".
        /// </summary>
        public readonly string ClientSecretName;
        /// <summary>
        /// CsiControllerSecretName references a secret holding the TLS key and certificate used by the CSI Controller to provision volumes. Defaults to "linstor-csi-controller-tls".
        /// </summary>
        public readonly string CsiControllerSecretName;
        /// <summary>
        /// CsiNodeSecretName references a secret holding the TLS key and certificate used by the CSI Nodes to query the volume state. Defaults to "linstor-csi-node-tls".
        /// </summary>
        public readonly string CsiNodeSecretName;

        [OutputConstructor]
        private LinstorClusterSpecApiTLS(
            string apiSecretName,

            Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorClusterSpecApiTLSCertManager certManager,

            string clientSecretName,

            string csiControllerSecretName,

            string csiNodeSecretName)
        {
            ApiSecretName = apiSecretName;
            CertManager = certManager;
            ClientSecretName = clientSecretName;
            CsiControllerSecretName = csiControllerSecretName;
            CsiNodeSecretName = csiNodeSecretName;
        }
    }
}