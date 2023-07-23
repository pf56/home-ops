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
    /// ArchiveSchedule manages schedules for the archival service
    /// </summary>
    [OutputType]
    public sealed class ScheduleSpecArchive
    {
        /// <summary>
        /// ActiveDeadlineSeconds specifies the duration in seconds relative to the startTime that the job may be continuously active before the system tries to terminate it. Value must be positive integer if given.
        /// </summary>
        public readonly int ActiveDeadlineSeconds;
        /// <summary>
        /// Backend contains the restic repo where the job should backup to.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveBackend Backend;
        public readonly bool ConcurrentRunsAllowed;
        /// <summary>
        /// FailedJobsHistoryLimit amount of failed jobs to keep for later analysis. KeepJobs is used property is not specified.
        /// </summary>
        public readonly int FailedJobsHistoryLimit;
        /// <summary>
        /// KeepJobs amount of jobs to keep for later analysis. 
        ///  Deprecated: Use FailedJobsHistoryLimit and SuccessfulJobsHistoryLimit respectively.
        /// </summary>
        public readonly int KeepJobs;
        /// <summary>
        /// PodSecurityContext describes the security context with which this action shall be executed.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchivePodSecurityContext PodSecurityContext;
        /// <summary>
        /// Resources describes the compute resource requirements (cpu, memory, etc.)
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveResources Resources;
        public readonly string RestoreFilter;
        /// <summary>
        /// RestoreMethod contains how and where the restore should happen all the settings are mutual exclusive.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveRestoreMethod RestoreMethod;
        /// <summary>
        /// ScheduleDefinition is the actual cron-type expression that defines the interval of the actions.
        /// </summary>
        public readonly string Schedule;
        public readonly string Snapshot;
        /// <summary>
        /// SuccessfulJobsHistoryLimit amount of successful jobs to keep for later analysis. KeepJobs is used property is not specified.
        /// </summary>
        public readonly int SuccessfulJobsHistoryLimit;
        /// <summary>
        /// Tags is a list of arbitrary tags that get added to the backup via Restic's tagging system
        /// </summary>
        public readonly ImmutableArray<string> Tags;

        [OutputConstructor]
        private ScheduleSpecArchive(
            int activeDeadlineSeconds,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveBackend backend,

            bool concurrentRunsAllowed,

            int failedJobsHistoryLimit,

            int keepJobs,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchivePodSecurityContext podSecurityContext,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveResources resources,

            string restoreFilter,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecArchiveRestoreMethod restoreMethod,

            string schedule,

            string snapshot,

            int successfulJobsHistoryLimit,

            ImmutableArray<string> tags)
        {
            ActiveDeadlineSeconds = activeDeadlineSeconds;
            Backend = backend;
            ConcurrentRunsAllowed = concurrentRunsAllowed;
            FailedJobsHistoryLimit = failedJobsHistoryLimit;
            KeepJobs = keepJobs;
            PodSecurityContext = podSecurityContext;
            Resources = resources;
            RestoreFilter = restoreFilter;
            RestoreMethod = restoreMethod;
            Schedule = schedule;
            Snapshot = snapshot;
            SuccessfulJobsHistoryLimit = successfulJobsHistoryLimit;
            Tags = tags;
        }
    }
}
