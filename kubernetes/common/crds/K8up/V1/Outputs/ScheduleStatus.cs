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
    /// ScheduleStatus defines the observed state of Schedule
    /// </summary>
    [OutputType]
    public sealed class ScheduleStatus
    {
        /// <summary>
        /// Conditions provide a standard mechanism for higher-level status reporting from a controller. They are an extension mechanism which allows tools and other controllers to collect summary information about resources without needing to understand resource-specific status details.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleStatusConditions> Conditions;
        /// <summary>
        /// EffectiveSchedules contains a list of schedules generated from randomizing schedules.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleStatusEffectiveSchedules> EffectiveSchedules;

        [OutputConstructor]
        private ScheduleStatus(
            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleStatusConditions> conditions,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleStatusEffectiveSchedules> effectiveSchedules)
        {
            Conditions = conditions;
            EffectiveSchedules = effectiveSchedules;
        }
    }
}