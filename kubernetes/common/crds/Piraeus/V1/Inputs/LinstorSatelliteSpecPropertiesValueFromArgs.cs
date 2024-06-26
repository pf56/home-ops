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
    /// ValueFrom sets the value from an existing resource.
    /// </summary>
    public class LinstorSatelliteSpecPropertiesValueFromArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Select a field of the node. Supports `metadata.name`, `metadata.labels['&lt;KEY&gt;']`, `metadata.annotations['&lt;KEY&gt;']`.
        /// </summary>
        [Input("nodeFieldRef")]
        public Input<string>? NodeFieldRef { get; set; }

        public LinstorSatelliteSpecPropertiesValueFromArgs()
        {
        }
        public static new LinstorSatelliteSpecPropertiesValueFromArgs Empty => new LinstorSatelliteSpecPropertiesValueFromArgs();
    }
}
