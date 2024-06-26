// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.Piraeus.V1
{

    /// <summary>
    /// LinstorSatelliteStatus defines the observed state of LinstorSatellite
    /// </summary>
    public class LinstorSatelliteStatusArgs : global::Pulumi.ResourceArgs
    {
        [Input("conditions")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteStatusConditionsArgs>? _conditions;

        /// <summary>
        /// Current LINSTOR Satellite state
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteStatusConditionsArgs> Conditions
        {
            get => _conditions ?? (_conditions = new InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteStatusConditionsArgs>());
            set => _conditions = value;
        }

        public LinstorSatelliteStatusArgs()
        {
        }
        public static new LinstorSatelliteStatusArgs Empty => new LinstorSatelliteStatusArgs();
    }
}
