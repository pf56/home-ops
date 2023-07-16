// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.Piraeus.V1
{

    /// <summary>
    /// Configures a file system based storage pool, allocating a sparse file per volume.
    /// </summary>
    [OutputType]
    public sealed class LinstorSatelliteSpecStoragePoolsFileThinPool
    {
        /// <summary>
        /// Directory is the path to the host directory used to store volume data.
        /// </summary>
        public readonly string Directory;

        [OutputConstructor]
        private LinstorSatelliteSpecStoragePoolsFileThinPool(string directory)
        {
            Directory = directory;
        }
    }
}