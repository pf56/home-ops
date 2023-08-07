using System.Linq;
using Components;
using Pulumi;
using Pulumi.Kubernetes.Apps.V1;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Apps.V1;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Types.Inputs.Networking.V1;

namespace Jellyfin;

public class Jellyfin : Stack
{
	public Jellyfin()
	{
		Config config = new();
		var resticRepo = config.RequireSecret("restic-repo");
		var resticPassword = config.RequireSecret("restic-password");

		string imageName = "jellyfin/jellyfin";
		string imageTag = "10.8.10";

		Namespace @namespace = new("jellyfin", new NamespaceArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "jellyfin"
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);
		InputMap<string> appLabels = new()
		{
			{ "app", "jellyfin" }
		};

		PersistentVolume pvTv = new("pv-jellyfin-tv", new PersistentVolumeArgs
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
					VolumeHandle = "jellyfin#storage.internal.paulfriedrich.me/mnt/tank/tv",
					VolumeAttributes =
					{
						["server"] = "10.0.60.3",
						["share"] = "/mnt/tank/tv",
						["node_attach_driver"] = "nfs",
						["provisioner_driver"] = "node-manual"
					}
				}
			}
		});

		PersistentVolume pvMovies = new("pv-jellyfin-movies", new PersistentVolumeArgs
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
					VolumeHandle = "jellyfin#storage.internal.paulfriedrich.me/mnt/tank/movies",
					VolumeAttributes =
					{
						["server"] = "10.0.60.3",
						["share"] = "/mnt/tank/movies",
						["node_attach_driver"] = "nfs",
						["provisioner_driver"] = "node-manual"
					}
				}
			}
		});

		PersistentVolumeClaim pvcMovies = new("pvc-jellyfin-movies",
			new PersistentVolumeClaimArgs
			{
				Metadata = new ObjectMetaArgs
				{
					Namespace = namespaceName,
					Labels = appLabels,
					Annotations =
					{
						{ "k8up.io/backup", "false" }
					}
				},
				Spec = new PersistentVolumeClaimSpecArgs
				{
					StorageClassName = "",
					VolumeName = pvMovies.Metadata.Apply(x => x.Name),
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

		PersistentVolumeClaim pvcTv = new("pvc-jellyfin-tv",
			new PersistentVolumeClaimArgs
			{
				Metadata = new ObjectMetaArgs
				{
					Namespace = namespaceName,
					Labels = appLabels,
					Annotations =
					{
						{ "k8up.io/backup", "false" }
					}
				},
				Spec = new PersistentVolumeClaimSpecArgs
				{
					StorageClassName = "",
					VolumeName = pvTv.Metadata.Apply(x => x.Name),
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

		Service service = new("jellyfin", new ServiceArgs
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

		StatefulSet jellyfin = new("jellyfin", new StatefulSetArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "jellyfin",
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
								Name = "jellyfin",
								Image = $"{imageName}:{imageTag}",
								Ports = new[]
								{
									new ContainerPortArgs
									{
										ContainerPortValue = 8096,
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
										MountPath = "/media/tv",
										Name = "tv"
									},
									new VolumeMountArgs
									{
										MountPath = "/media/movies",
										Name = "movies"
									}
								}
							}
						},
						SecurityContext = new PodSecurityContextArgs
						{
							FsGroup = 1001
						},
						Volumes = new[]
						{
							new VolumeArgs
							{
								Name = "tv",
								PersistentVolumeClaim = new PersistentVolumeClaimVolumeSourceArgs
								{
									ClaimName = pvcTv.Metadata.Apply(x => x.Name)
								}
							},
							new VolumeArgs
							{
								Name = "movies",
								PersistentVolumeClaim = new PersistentVolumeClaimVolumeSourceArgs
								{
									ClaimName = pvcMovies.Metadata.Apply(x => x.Name)
								}
							}
						}
					}
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
					}
				}
			}
		}, new CustomResourceOptions { DeleteBeforeReplace = true });

		DefaultIngress ingress = new("jellyfin", new DefaultIngressArgs
		{
			Namespace = namespaceName,
			Labels = appLabels,
			IngressRules = new InputList<IngressRuleArgs>
			{
				new IngressRuleArgs
				{
					Host = "jellyfin.internal.paulfriedrich.me",
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
					"jellyfin.internal.paulfriedrich.me"
				}
			}
		});

		Secret resticCredentials = new("restic-credentials", new SecretArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Namespace = namespaceName
			},
			StringData =
			{
				{ "password", resticPassword }
			}
		});

		DefaultBackupSchedule backupSchedule = new("sabnzbd", new DefaultBackupScheduleArgs
		{
			Namespace = namespaceName,
			Labels = appLabels,
			RepoUrl = resticRepo,
			RepoCredentialsName = resticCredentials.Metadata.Apply(x => x.Name),
			RepoCredentialsKey = "password"
		});
	}
}