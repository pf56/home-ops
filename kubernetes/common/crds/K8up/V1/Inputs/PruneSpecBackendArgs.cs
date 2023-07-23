// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    /// <summary>
    /// Backend contains the restic repo where the job should backup to.
    /// </summary>
    public class PruneSpecBackendArgs : global::Pulumi.ResourceArgs
    {
        [Input("azure")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendAzureArgs>? Azure { get; set; }

        [Input("b2")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendB2Args>? B2 { get; set; }

        [Input("envFrom")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendEnvFromArgs>? _envFrom;

        /// <summary>
        /// EnvFrom adds all environment variables from a an external source to the Restic job.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendEnvFromArgs> EnvFrom
        {
            get => _envFrom ?? (_envFrom = new InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendEnvFromArgs>());
            set => _envFrom = value;
        }

        [Input("gcs")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendGcsArgs>? Gcs { get; set; }

        [Input("local")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendLocalArgs>? Local { get; set; }

        /// <summary>
        /// RepoPasswordSecretRef references a secret key to look up the restic repository password
        /// </summary>
        [Input("repoPasswordSecretRef")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendRepoPasswordSecretRefArgs>? RepoPasswordSecretRef { get; set; }

        [Input("rest")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendRestArgs>? Rest { get; set; }

        [Input("s3")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendS3Args>? S3 { get; set; }

        [Input("swift")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendSwiftArgs>? Swift { get; set; }

        public PruneSpecBackendArgs()
        {
        }
        public static new PruneSpecBackendArgs Empty => new PruneSpecBackendArgs();
    }
}
