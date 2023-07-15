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
    /// Condition contains details for one aspect of the current state of this API Resource. --- This struct is intended for direct use as an array at the field path .status.conditions.  For example, 
    ///  type FooStatus struct{ // Represents the observations of a foo's current state. // Known .status.conditions.type are: "Available", "Progressing", and "Degraded" // +patchMergeKey=type // +patchStrategy=merge // +listType=map // +listMapKey=type Conditions []metav1.Condition `json:"conditions,omitempty" patchStrategy:"merge" patchMergeKey:"type" protobuf:"bytes,1,rep,name=conditions"` 
    ///  // other fields }
    /// </summary>
    public class LinstorSatelliteConfigurationStatusConditionsArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable.
        /// </summary>
        [Input("lastTransitionTime", required: true)]
        public Input<string> LastTransitionTime { get; set; } = null!;

        /// <summary>
        /// message is a human readable message indicating details about the transition. This may be an empty string.
        /// </summary>
        [Input("message", required: true)]
        public Input<string> Message { get; set; } = null!;

        /// <summary>
        /// observedGeneration represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date with respect to the current state of the instance.
        /// </summary>
        [Input("observedGeneration")]
        public Input<int>? ObservedGeneration { get; set; }

        /// <summary>
        /// reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty.
        /// </summary>
        [Input("reason", required: true)]
        public Input<string> Reason { get; set; } = null!;

        /// <summary>
        /// status of the condition, one of True, False, Unknown.
        /// </summary>
        [Input("status", required: true)]
        public Input<string> Status { get; set; } = null!;

        /// <summary>
        /// type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt)
        /// </summary>
        [Input("type", required: true)]
        public Input<string> Type { get; set; } = null!;

        public LinstorSatelliteConfigurationStatusConditionsArgs()
        {
        }
        public static new LinstorSatelliteConfigurationStatusConditionsArgs Empty => new LinstorSatelliteConfigurationStatusConditionsArgs();
    }
}
