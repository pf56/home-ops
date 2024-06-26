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
    /// TLSStoreSpec defines the desired state of a TLSStore.
    /// </summary>
    [OutputType]
    public sealed class TLSStoreSpec
    {
        /// <summary>
        /// Certificates is a list of secret names, each secret holding a key/certificate pair to add to the store.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSStoreSpecCertificates> Certificates;
        /// <summary>
        /// DefaultCertificate defines the default certificate configuration.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSStoreSpecDefaultCertificate DefaultCertificate;
        /// <summary>
        /// DefaultGeneratedCert defines the default generated certificate configuration.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSStoreSpecDefaultGeneratedCert DefaultGeneratedCert;

        [OutputConstructor]
        private TLSStoreSpec(
            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSStoreSpecCertificates> certificates,

            Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSStoreSpecDefaultCertificate defaultCertificate,

            Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSStoreSpecDefaultGeneratedCert defaultGeneratedCert)
        {
            Certificates = certificates;
            DefaultCertificate = defaultCertificate;
            DefaultGeneratedCert = defaultGeneratedCert;
        }
    }
}
