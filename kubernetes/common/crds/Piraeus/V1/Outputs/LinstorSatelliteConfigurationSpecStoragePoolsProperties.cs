// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.Piraeus.V1
{

    [OutputType]
    public sealed class LinstorSatelliteConfigurationSpecStoragePoolsProperties
    {
        /// <summary>
        /// Name of the property to set.
        /// </summary>
        public readonly string Name;
        /// <summary>
        /// Optional values are only set if they have a non-empty value
        /// </summary>
        public readonly bool Optional;
        /// <summary>
        /// Value to set the property to.
        /// </summary>
        public readonly string Value;
        /// <summary>
        /// ValueFrom sets the value from an existing resource.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsPropertiesValueFrom ValueFrom;

        [OutputConstructor]
        private LinstorSatelliteConfigurationSpecStoragePoolsProperties(
            string name,

            bool optional,

            string value,

            Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsPropertiesValueFrom valueFrom)
        {
            Name = name;
            Optional = optional;
            Value = value;
            ValueFrom = valueFrom;
        }
    }
}
