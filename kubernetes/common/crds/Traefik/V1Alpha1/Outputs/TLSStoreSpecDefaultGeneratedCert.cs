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
    /// DefaultGeneratedCert defines the default generated certificate configuration.
    /// </summary>
    [OutputType]
    public sealed class TLSStoreSpecDefaultGeneratedCert
    {
        /// <summary>
        /// Domain is the domain definition for the DefaultCertificate.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSStoreSpecDefaultGeneratedCertDomain Domain;
        /// <summary>
        /// Resolver is the name of the resolver that will be used to issue the DefaultCertificate.
        /// </summary>
        public readonly string Resolver;

        [OutputConstructor]
        private TLSStoreSpecDefaultGeneratedCert(
            Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSStoreSpecDefaultGeneratedCertDomain domain,

            string resolver)
        {
            Domain = domain;
            Resolver = resolver;
        }
    }
}
