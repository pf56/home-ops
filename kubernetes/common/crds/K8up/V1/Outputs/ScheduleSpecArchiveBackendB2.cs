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
    public sealed class ScheduleSpecArchiveBackendB2
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveBackendB2AccountIDSecretRef AccountIDSecretRef;
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveBackendB2AccountKeySecretRef AccountKeySecretRef;
        public readonly string Bucket;
        public readonly string Path;

        [OutputConstructor]
        private ScheduleSpecArchiveBackendB2(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveBackendB2AccountIDSecretRef accountIDSecretRef,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveBackendB2AccountKeySecretRef accountKeySecretRef,

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
