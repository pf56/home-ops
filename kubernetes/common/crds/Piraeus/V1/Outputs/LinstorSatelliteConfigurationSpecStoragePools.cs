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
    public sealed class LinstorSatelliteConfigurationSpecStoragePools
    {
        /// <summary>
        /// Configures a file system based storage pool, allocating a regular file per volume.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsFilePool FilePool;
        /// <summary>
        /// Configures a file system based storage pool, allocating a sparse file per volume.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsFileThinPool FileThinPool;
        /// <summary>
        /// Configures a LVM Volume Group as storage pool.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsLvmPool LvmPool;
        /// <summary>
        /// Configures a LVM Thin Pool as storage pool.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsLvmThinPool LvmThinPool;
        /// <summary>
        /// Name of the storage pool in linstor.
        /// </summary>
        public readonly string Name;
        /// <summary>
        /// Properties to set on the storage pool.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsProperties> Properties;
        public readonly Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsSource Source;

        [OutputConstructor]
        private LinstorSatelliteConfigurationSpecStoragePools(
            Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsFilePool filePool,

            Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsFileThinPool fileThinPool,

            Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsLvmPool lvmPool,

            Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsLvmThinPool lvmThinPool,

            string name,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsProperties> properties,

            Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpecStoragePoolsSource source)
        {
            FilePool = filePool;
            FileThinPool = fileThinPool;
            LvmPool = lvmPool;
            LvmThinPool = lvmThinPool;
            Name = name;
            Properties = properties;
            Source = source;
        }
    }
}
