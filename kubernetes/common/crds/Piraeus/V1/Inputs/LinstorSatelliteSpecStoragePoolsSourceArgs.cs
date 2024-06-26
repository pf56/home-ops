// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.Piraeus.V1
{

    public class LinstorSatelliteSpecStoragePoolsSourceArgs : global::Pulumi.ResourceArgs
    {
        [Input("hostDevices")]
        private InputList<string>? _hostDevices;

        /// <summary>
        /// HostDevices is a list of device paths used to configure the given pool.
        /// </summary>
        public InputList<string> HostDevices
        {
            get => _hostDevices ?? (_hostDevices = new InputList<string>());
            set => _hostDevices = value;
        }

        public LinstorSatelliteSpecStoragePoolsSourceArgs()
        {
        }
        public static new LinstorSatelliteSpecStoragePoolsSourceArgs Empty => new LinstorSatelliteSpecStoragePoolsSourceArgs();
    }
}
