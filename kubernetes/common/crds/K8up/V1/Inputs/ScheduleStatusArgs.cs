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
    /// ScheduleStatus defines the observed state of Schedule
    /// </summary>
    public class ScheduleStatusArgs : global::Pulumi.ResourceArgs
    {
        [Input("conditions")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleStatusConditionsArgs>? _conditions;

        /// <summary>
        /// Conditions provide a standard mechanism for higher-level status reporting from a controller. They are an extension mechanism which allows tools and other controllers to collect summary information about resources without needing to understand resource-specific status details.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleStatusConditionsArgs> Conditions
        {
            get => _conditions ?? (_conditions = new InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleStatusConditionsArgs>());
            set => _conditions = value;
        }

        [Input("effectiveSchedules")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleStatusEffectiveSchedulesArgs>? _effectiveSchedules;

        /// <summary>
        /// EffectiveSchedules contains a list of schedules generated from randomizing schedules.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleStatusEffectiveSchedulesArgs> EffectiveSchedules
        {
            get => _effectiveSchedules ?? (_effectiveSchedules = new InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleStatusEffectiveSchedulesArgs>());
            set => _effectiveSchedules = value;
        }

        public ScheduleStatusArgs()
        {
        }
        public static new ScheduleStatusArgs Empty => new ScheduleStatusArgs();
    }
}
