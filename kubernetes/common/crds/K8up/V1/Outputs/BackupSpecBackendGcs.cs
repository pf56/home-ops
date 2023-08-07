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
    public sealed class BackupSpecBackendGcs
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.BackupSpecBackendGcsAccessTokenSecretRef AccessTokenSecretRef;
        public readonly string Bucket;
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.BackupSpecBackendGcsProjectIDSecretRef ProjectIDSecretRef;

        [OutputConstructor]
        private BackupSpecBackendGcs(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.BackupSpecBackendGcsAccessTokenSecretRef accessTokenSecretRef,

            string bucket,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.BackupSpecBackendGcsProjectIDSecretRef projectIDSecretRef)
        {
            AccessTokenSecretRef = accessTokenSecretRef;
            Bucket = bucket;
            ProjectIDSecretRef = projectIDSecretRef;
        }
    }
}