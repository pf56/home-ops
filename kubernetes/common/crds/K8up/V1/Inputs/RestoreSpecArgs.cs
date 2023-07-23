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
    /// RestoreSpec can either contain an S3 restore point or a local one. For the local one you need to define an existing PVC.
    /// </summary>
    public class RestoreSpecArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// ActiveDeadlineSeconds specifies the duration in seconds relative to the startTime that the job may be continuously active before the system tries to terminate it. Value must be positive integer if given.
        /// </summary>
        [Input("activeDeadlineSeconds")]
        public Input<int>? ActiveDeadlineSeconds { get; set; }

        /// <summary>
        /// Backend contains the restic repo where the job should backup to.
        /// </summary>
        [Input("backend")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.RestoreSpecBackendArgs>? Backend { get; set; }

        /// <summary>
        /// FailedJobsHistoryLimit amount of failed jobs to keep for later analysis. KeepJobs is used property is not specified.
        /// </summary>
        [Input("failedJobsHistoryLimit")]
        public Input<int>? FailedJobsHistoryLimit { get; set; }

        /// <summary>
        /// KeepJobs amount of jobs to keep for later analysis. 
        ///  Deprecated: Use FailedJobsHistoryLimit and SuccessfulJobsHistoryLimit respectively.
        /// </summary>
        [Input("keepJobs")]
        public Input<int>? KeepJobs { get; set; }

        /// <summary>
        /// PodSecurityContext describes the security context with which this action shall be executed.
        /// </summary>
        [Input("podSecurityContext")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.RestoreSpecPodSecurityContextArgs>? PodSecurityContext { get; set; }

        /// <summary>
        /// Resources describes the compute resource requirements (cpu, memory, etc.)
        /// </summary>
        [Input("resources")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.RestoreSpecResourcesArgs>? Resources { get; set; }

        [Input("restoreFilter")]
        public Input<string>? RestoreFilter { get; set; }

        /// <summary>
        /// RestoreMethod contains how and where the restore should happen all the settings are mutual exclusive.
        /// </summary>
        [Input("restoreMethod")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.RestoreSpecRestoreMethodArgs>? RestoreMethod { get; set; }

        [Input("snapshot")]
        public Input<string>? Snapshot { get; set; }

        /// <summary>
        /// SuccessfulJobsHistoryLimit amount of successful jobs to keep for later analysis. KeepJobs is used property is not specified.
        /// </summary>
        [Input("successfulJobsHistoryLimit")]
        public Input<int>? SuccessfulJobsHistoryLimit { get; set; }

        [Input("tags")]
        private InputList<string>? _tags;

        /// <summary>
        /// Tags is a list of arbitrary tags that get added to the backup via Restic's tagging system
        /// </summary>
        public InputList<string> Tags
        {
            get => _tags ?? (_tags = new InputList<string>());
            set => _tags = value;
        }

        public RestoreSpecArgs()
        {
        }
        public static new RestoreSpecArgs Empty => new RestoreSpecArgs();
    }
}
