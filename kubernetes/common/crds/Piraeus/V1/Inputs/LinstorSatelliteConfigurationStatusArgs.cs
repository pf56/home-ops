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
    /// LinstorSatelliteConfigurationStatus defines the observed state of LinstorSatelliteConfiguration
    /// </summary>
    public class LinstorSatelliteConfigurationStatusArgs : global::Pulumi.ResourceArgs
    {
        [Input("conditions")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteConfigurationStatusConditionsArgs>? _conditions;

        /// <summary>
        /// Current LINSTOR Satellite Config state
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteConfigurationStatusConditionsArgs> Conditions
        {
            get => _conditions ?? (_conditions = new InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteConfigurationStatusConditionsArgs>());
            set => _conditions = value;
        }

        public LinstorSatelliteConfigurationStatusArgs()
        {
        }
        public static new LinstorSatelliteConfigurationStatusArgs Empty => new LinstorSatelliteConfigurationStatusArgs();
    }
}
