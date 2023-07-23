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
    /// EffectiveScheduleSpec defines the desired state of EffectiveSchedule
    /// </summary>
    [OutputType]
    public sealed class EffectiveScheduleSpec
    {
        /// <summary>
        /// GeneratedSchedule is the effective schedule that is added to Cron
        /// </summary>
        public readonly string GeneratedSchedule;
        /// <summary>
        /// JobType defines to which job type this schedule applies
        /// </summary>
        public readonly string JobType;
        /// <summary>
        /// OriginalSchedule is the original user-defined schedule definition in the Schedule object.
        /// </summary>
        public readonly string OriginalSchedule;
        /// <summary>
        /// ScheduleRefs holds a list of schedules for which the generated schedule applies to. The list may omit entries that aren't generated from smart schedules.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.EffectiveScheduleSpecScheduleRefs> ScheduleRefs;

        [OutputConstructor]
        private EffectiveScheduleSpec(
            string generatedSchedule,

            string jobType,

            string originalSchedule,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.EffectiveScheduleSpecScheduleRefs> scheduleRefs)
        {
            GeneratedSchedule = generatedSchedule;
            JobType = jobType;
            OriginalSchedule = originalSchedule;
            ScheduleRefs = scheduleRefs;
        }
    }
}
