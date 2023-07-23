// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.K8up.V1
{

    /// <summary>
    /// Backend contains the restic repo where the job should backup to.
    /// </summary>
    [OutputType]
    public sealed class ScheduleSpecCheckBackend
    {
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendAzure Azure;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendB2 B2;
        /// <summary>
        /// EnvFrom adds all environment variables from a an external source to the Restic job.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendEnvFrom> EnvFrom;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendGcs Gcs;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendLocal Local;
        /// <summary>
        /// RepoPasswordSecretRef references a secret key to look up the restic repository password
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendRepoPasswordSecretRef RepoPasswordSecretRef;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendRest Rest;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendS3 S3;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendSwift Swift;

        [OutputConstructor]
        private ScheduleSpecCheckBackend(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendAzure azure,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendB2 b2,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendEnvFrom> envFrom,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendGcs gcs,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendLocal local,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendRepoPasswordSecretRef repoPasswordSecretRef,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendRest rest,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendS3 s3,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendSwift swift)
        {
            Azure = azure;
            B2 = b2;
            EnvFrom = envFrom;
            Gcs = gcs;
            Local = local;
            RepoPasswordSecretRef = repoPasswordSecretRef;
            Rest = rest;
            S3 = s3;
            Swift = swift;
        }
    }
}
