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
    public sealed class ArchiveSpecBackend
    {
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendAzure Azure;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendB2 B2;
        /// <summary>
        /// EnvFrom adds all environment variables from a an external source to the Restic job.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendEnvFrom> EnvFrom;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendGcs Gcs;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendLocal Local;
        /// <summary>
        /// RepoPasswordSecretRef references a secret key to look up the restic repository password
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendRepoPasswordSecretRef RepoPasswordSecretRef;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendRest Rest;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendS3 S3;
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendSwift Swift;

        [OutputConstructor]
        private ArchiveSpecBackend(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendAzure azure,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendB2 b2,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendEnvFrom> envFrom,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendGcs gcs,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendLocal local,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendRepoPasswordSecretRef repoPasswordSecretRef,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendRest rest,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendS3 s3,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ArchiveSpecBackendSwift swift)
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
