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
    /// Configures a LVM Volume Group as storage pool.
    /// </summary>
    public class LinstorSatelliteConfigurationSpecStoragePoolsLvmPoolArgs : global::Pulumi.ResourceArgs
    {
        [Input("volumeGroup")]
        public Input<string>? VolumeGroup { get; set; }

        public LinstorSatelliteConfigurationSpecStoragePoolsLvmPoolArgs()
        {
        }
        public static new LinstorSatelliteConfigurationSpecStoragePoolsLvmPoolArgs Empty => new LinstorSatelliteConfigurationSpecStoragePoolsLvmPoolArgs();
    }
}
