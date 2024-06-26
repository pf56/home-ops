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
    /// PruneSchedule manages the schedules for the prunes
    /// </summary>
    public class ScheduleSpecPruneArgs : global::Pulumi.ResourceArgs
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
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleSpecPruneBackendArgs>? Backend { get; set; }

        [Input("concurrentRunsAllowed")]
        public Input<bool>? ConcurrentRunsAllowed { get; set; }

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
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleSpecPrunePodSecurityContextArgs>? PodSecurityContext { get; set; }

        /// <summary>
        /// Resources describes the compute resource requirements (cpu, memory, etc.)
        /// </summary>
        [Input("resources")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleSpecPruneResourcesArgs>? Resources { get; set; }

        /// <summary>
        /// Retention sets how many backups should be kept after a forget and prune
        /// </summary>
        [Input("retention")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleSpecPruneRetentionArgs>? Retention { get; set; }

        /// <summary>
        /// ScheduleDefinition is the actual cron-type expression that defines the interval of the actions.
        /// </summary>
        [Input("schedule")]
        public Input<string>? Schedule { get; set; }

        /// <summary>
        /// SuccessfulJobsHistoryLimit amount of successful jobs to keep for later analysis. KeepJobs is used property is not specified.
        /// </summary>
        [Input("successfulJobsHistoryLimit")]
        public Input<int>? SuccessfulJobsHistoryLimit { get; set; }

        public ScheduleSpecPruneArgs()
        {
        }
        public static new ScheduleSpecPruneArgs Empty => new ScheduleSpecPruneArgs();
    }
}
