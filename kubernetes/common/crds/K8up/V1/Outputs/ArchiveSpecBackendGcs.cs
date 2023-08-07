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
    public sealed class ArchiveSpecBackendGcs
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendGcsAccessTokenSecretRef AccessTokenSecretRef;
        public readonly string Bucket;
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendGcsProjectIDSecretRef ProjectIDSecretRef;

        [OutputConstructor]
        private ArchiveSpecBackendGcs(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendGcsAccessTokenSecretRef accessTokenSecretRef,

            string bucket,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendGcsProjectIDSecretRef projectIDSecretRef)
        {
            AccessTokenSecretRef = accessTokenSecretRef;
            Bucket = bucket;
            ProjectIDSecretRef = projectIDSecretRef;
        }
    }
}