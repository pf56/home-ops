// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.Certmanager.V1
{

    /// <summary>
    /// Status of the ClusterIssuer. This is set and managed automatically.
    /// </summary>
    [OutputType]
    public sealed class ClusterIssuerStatus
    {
        /// <summary>
        /// ACME specific status options. This field should only be set if the Issuer is configured to use an ACME server to issue certificates.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Certmanager.V1.ClusterIssuerStatusAcme Acme;
        /// <summary>
        /// List of status conditions to indicate the status of a CertificateRequest. Known condition types are `Ready`.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Certmanager.V1.ClusterIssuerStatusConditions> Conditions;

        [OutputConstructor]
        private ClusterIssuerStatus(
            Pulumi.Kubernetes.Types.Outputs.Certmanager.V1.ClusterIssuerStatusAcme acme,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Certmanager.V1.ClusterIssuerStatusConditions> conditions)
        {
            Acme = acme;
            Conditions = conditions;
        }
    }
}