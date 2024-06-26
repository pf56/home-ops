// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.K8up.V1
{

    [OutputType]
    public sealed class ArchiveSpecBackendB2
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendB2AccountIDSecretRef AccountIDSecretRef;
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendB2AccountKeySecretRef AccountKeySecretRef;
        public readonly string Bucket;
        public readonly string Path;

        [OutputConstructor]
        private ArchiveSpecBackendB2(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendB2AccountIDSecretRef accountIDSecretRef,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendB2AccountKeySecretRef accountKeySecretRef,

            string bucket,

            string path)
        {
            AccountIDSecretRef = accountIDSecretRef;
            AccountKeySecretRef = accountKeySecretRef;
            Bucket = bucket;
            Path = path;
        }
    }
}
