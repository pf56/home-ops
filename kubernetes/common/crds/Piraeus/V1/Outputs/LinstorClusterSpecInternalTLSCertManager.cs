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
    /// CertManager references a cert-manager Issuer or ClusterIssuer. If set, a Certificate resource will be created, provisioning the secret references in SecretName using the issuer configured here.
    /// </summary>
    [OutputType]
    public sealed class LinstorClusterSpecInternalTLSCertManager
    {
        /// <summary>
        /// Group of the resource being referred to.
        /// </summary>
        public readonly string Group;
        /// <summary>
        /// Kind of the resource being referred to.
        /// </summary>
        public readonly string Kind;
        /// <summary>
        /// Name of the resource being referred to.
        /// </summary>
        public readonly string Name;

        [OutputConstructor]
        private LinstorClusterSpecInternalTLSCertManager(
            string group,

            string kind,

            string name)
        {
            Group = group;
            Kind = kind;
            Name = name;
        }
    }
}
