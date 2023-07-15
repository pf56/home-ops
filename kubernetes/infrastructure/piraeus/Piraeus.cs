#nullable enable
using System.Collections.Generic;
using Pulumi;
using Pulumi.Crds.Piraeus.V1;
using Pulumi.Kubernetes.Kustomize;
using Pulumi.Kubernetes.Storage.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Types.Inputs.Piraeus.V1;
using Pulumi.Kubernetes.Types.Inputs.Storage.V1;
using Pulumi.Kubernetes.Yaml;

namespace Piraeus;

public class Piraeus : Stack
{
	public Piraeus()
	{
		var piraeusOperator = new Directory("piraeus-operator", new DirectoryArgs
		{
			Directory = "./piraeus-operator/config/default"
		});

		// applying the override will fail on the first deploy, since the piraeus operator isn't running
		var talosLoaderOverride = new ConfigFile("talos-loader-override", new ConfigFileArgs
		{
			File = "talos-loader-override.yaml"
		});

		var linstorCluster = new LinstorCluster("linstor-cluster", new LinstorClusterArgs
		{
			Spec = new LinstorClusterSpecArgs
			{
				NodeSelector =
				{
					{ "paulfriedrich.me/linstor", "yes" }
				}
			}
		});

		var pool0 = new LinstorSatelliteConfiguration("linstor-pool-0", new LinstorSatelliteConfigurationArgs
		{
			Spec = new LinstorSatelliteConfigurationSpecArgs
			{
				StoragePools =
				{
					new LinstorSatelliteConfigurationSpecStoragePoolsArgs
					{
						Name = "pool-0",
						FileThinPool = new LinstorSatelliteConfigurationSpecStoragePoolsFileThinPoolArgs
						{
							Directory = "/var/mnt/linstor-0"
						}
					}
				}
			}
		});

		var storageClass = new StorageClass("storageclass-linstor-pool-0", new StorageClassArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "piraeus-storage"
			},
			Provisioner = "linstor.csi.linbit.com",
			AllowVolumeExpansion = true,
			VolumeBindingMode = "WaitForFirstConsumer",
			Parameters =
			{
				{ "linstor.csi.linbit.com/storagePool", "pool-0" }
			}
		});

		var storageClassReplicated = new StorageClass("storageclass-linstor-replicated-pool-0", new StorageClassArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "piraeus-storage-replicated"
			},
			Provisioner = "linstor.csi.linbit.com",
			AllowVolumeExpansion = true,
			VolumeBindingMode = "WaitForFirstConsumer",
			Parameters =
			{
				{ "linstor.csi.linbit.com/storagePool", "pool-0" },
				{ "linstor.csi.linbit.com/placementCount", "2" }
			}
		});
	}
}