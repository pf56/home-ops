using System.Linq;
using Components;
using Pulumi;
using Pulumi.Kubernetes.Apps.V1;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Apps.V1;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Types.Inputs.Networking.V1;

namespace Sabnzbd;

public class Sabnzbd : Stack
{
	public Sabnzbd()
	{
		string imageName = "linuxserver/sabnzbd";
		string imageTag = "4.0.3";

		Namespace @namespace = new("sabnzbd", new NamespaceArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "sabnzbd"
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);
		InputMap<string> appLabels = new()
		{
			{ "app", "sabnzbd" }
		};

		var pvDownloads = new PersistentVolume("pv-sabnzbd-downloads", new PersistentVolumeArgs
		{
			Spec = new PersistentVolumeSpecArgs
			{
				Capacity =
				{
					["storage"] = "100Ti"
				},
				AccessModes =
				{
					"ReadWriteMany"
				},
				PersistentVolumeReclaimPolicy = "Retain",
				MountOptions =
				{
					"nfsvers=3",
					"nolock",
					"noatime"
				},
				Csi = new CSIPersistentVolumeSourceArgs
				{
					Driver = "org.democratic-csi.node-manual",
					ReadOnly = false,
					FsType = "nfs",
					VolumeHandle = "sabnzbd#storage.internal.paulfriedrich.me/mnt/tank/downloads",
					VolumeAttributes =
					{
						["server"] = "10.0.60.3",
						["share"] = "/mnt/tank/downloads",
						["node_attach_driver"] = "nfs",
						["provisioner_driver"] = "node-manual"
					}
				}
			}
		});

		PersistentVolumeClaim pvcSabnzbdDownloads = new("pvc-sabnzbd-downloads",
			new PersistentVolumeClaimArgs
			{
				Metadata = new ObjectMetaArgs
				{
					Namespace = namespaceName,
					Labels = appLabels
				},
				Spec = new PersistentVolumeClaimSpecArgs
				{
					StorageClassName = "",
					VolumeName = pvDownloads.Metadata.Apply(x => x.Name),
					AccessModes =
					{
						"ReadWriteMany"
					},
					Resources = new ResourceRequirementsArgs
					{
						Requests =
						{
							["storage"] = "100Ti"
						}
					}
				}
			});

		Service service = new("sabnzbd", new ServiceArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Namespace = namespaceName,
				Labels = appLabels,
				Annotations =
				{
					{
						"pulumi.com/skipAwait", "true"
					} // https://github.com/pulumi/pulumi-kubernetes/issues/1995
				}
			},
			Spec = new ServiceSpecArgs
			{
				Selector = appLabels,
				Ports = new[]
				{
					new ServicePortArgs
					{
						Name = "http",
						Port = 80,
						Protocol = "TCP",
						TargetPort = "web-ui"
					}
				}
			}
		});

		StatefulSet sabnzbd = new("sabnzbd", new StatefulSetArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "sabnzbd",
				Namespace = namespaceName,
				Labels = appLabels
			},
			Spec = new StatefulSetSpecArgs
			{
				Replicas = 1,
				ServiceName = service.Metadata.Apply(x => x.Name),
				Selector = new LabelSelectorArgs
				{
					MatchLabels = appLabels
				},
				Template = new PodTemplateSpecArgs
				{
					Metadata = new ObjectMetaArgs
					{
						Labels = appLabels
					},
					Spec = new PodSpecArgs
					{
						Containers = new[]
						{
							new ContainerArgs
							{
								Name = "sabnzbd",
								Image = $"{imageName}:{imageTag}",
								Env =
								{
									new EnvVarArgs
									{
										Name = "PUID",
										Value = "1001"
									},
									new EnvVarArgs
									{
										Name = "PGID",
										Value = "1001"
									}
								},
								Ports = new[]
								{
									new ContainerPortArgs
									{
										ContainerPortValue = 8080,
										Name = "web-ui",
										Protocol = "TCP"
									}
								},
								VolumeMounts = new[]
								{
									new VolumeMountArgs
									{
										MountPath = "/config",
										Name = "data"
									},
									new VolumeMountArgs
									{
										MountPath = "/downloads-complete",
										Name = "downloads"
									},
									new VolumeMountArgs
									{
										MountPath = "/tmpdata",
										Name = "tmp"
									}
								}
							}
						},
						SecurityContext = new PodSecurityContextArgs
						{
							FsGroup = 1001
						},
						Volumes =
						{
							new VolumeArgs
							{
								Name = "downloads",
								PersistentVolumeClaim = new PersistentVolumeClaimVolumeSourceArgs
								{
									ClaimName = pvcSabnzbdDownloads.Metadata.Apply(x => x.Name)
								}
							}
						}
					},
				},
				VolumeClaimTemplates =
				{
					new PersistentVolumeClaimArgs
					{
						Metadata = new ObjectMetaArgs
						{
							Name = "data",
							Namespace = namespaceName
						},
						Spec = new PersistentVolumeClaimSpecArgs
						{
							StorageClassName = "freenas-api-iscsi-csi",
							AccessModes = "ReadWriteOnce",
							Resources = new ResourceRequirementsArgs
							{
								Requests =
								{
									{ "storage", "8Gi" }
								}
							}
						}
					},
					new PersistentVolumeClaimArgs
					{
						Metadata = new ObjectMetaArgs
						{
							Name = "tmp",
							Namespace = namespaceName
						},
						Spec = new PersistentVolumeClaimSpecArgs
						{
							StorageClassName = "freenas-api-iscsi-csi",
							AccessModes = "ReadWriteOnce",
							Resources = new ResourceRequirementsArgs
							{
								Requests =
								{
									{ "storage", "128Gi" }
								}
							}
						}
					}
				}
			}
		}, new CustomResourceOptions { DeleteBeforeReplace = true });

		DefaultIngress ingress = new("sabnzbd", new DefaultIngressArgs
		{
			Namespace = namespaceName,
			Labels = appLabels,
			IngressRules = new InputList<IngressRuleArgs>
			{
				new IngressRuleArgs
				{
					Host = "sabnzbd.internal.paulfriedrich.me",
					Http = new HTTPIngressRuleValueArgs
					{
						Paths = new[]
						{
							new HTTPIngressPathArgs
							{
								Backend = new IngressBackendArgs
								{
									Service = new IngressServiceBackendArgs
									{
										Name = service.Metadata.Apply(x => x.Name),
										Port = new ServiceBackendPortArgs
										{
											Name = service.Spec.Apply(x => x.Ports.First().Name)
										}
									}
								},
								Path = "/",
								PathType = "Prefix"
							}
						}
					}
				}
			},
			Tls = new IngressTLSArgs
			{
				Hosts =
				{
					"sabnzbd.internal.paulfriedrich.me"
				}
			}
		});
	}
}