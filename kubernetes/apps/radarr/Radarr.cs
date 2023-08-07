using System.Linq;
using Components;
using Pulumi;
using Pulumi.Kubernetes.Apps.V1;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Apps.V1;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Types.Inputs.Networking.V1;

namespace Radarr;

public class Radarr : Stack
{
	public Radarr()
	{
		Config config = new();
		var resticRepo = config.RequireSecret("restic-repo");
		var resticPassword = config.RequireSecret("restic-password");

		string imageName = "linuxserver/radarr";
		string imageTag = "4.6.4.7568-ls180";

		Namespace @namespace = new("radarr", new NamespaceArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "radarr"
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);
		InputMap<string> appLabels = new()
		{
			{ "app", "radarr" }
		};

		PersistentVolume pvDownloads = new("pv-radarr-downloads", new PersistentVolumeArgs
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
					VolumeHandle = "radarr#storage.internal.paulfriedrich.me/mnt/tank/downloads",
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

		PersistentVolume pvMovies = new("pv-radarr-movies", new PersistentVolumeArgs
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
					VolumeHandle = "radarr#storage.internal.paulfriedrich.me/mnt/tank/movies",
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

		PersistentVolumeClaim pvcDownloads = new("pvc-radarr-downloads",
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

		PersistentVolumeClaim pvcMovies = new("pvc-radarr-movies",
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

		Service service = new("radarr", new ServiceArgs
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

		StatefulSet radarr = new("radarr", new StatefulSetArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "radarr",
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
								Name = "radarr",
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
										ContainerPortValue = 7878,
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
										MountPath = "/downloads",
										Name = "downloads"
									},
									new VolumeMountArgs
									{
										MountPath = "/movies",
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
								Name = "downloads",
								PersistentVolumeClaim = new PersistentVolumeClaimVolumeSourceArgs
								{
									ClaimName = pvcDownloads.Metadata.Apply(x => x.Name)
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

		DefaultIngress ingress = new("radarr", new DefaultIngressArgs
		{
			Namespace = namespaceName,
			Labels = appLabels,
			IngressRules = new InputList<IngressRuleArgs>
			{
				new IngressRuleArgs
				{
					Host = "radarr.internal.paulfriedrich.me",
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
					"radarr.internal.paulfriedrich.me"
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

		DefaultBackupSchedule backupSchedule = new("sonarr", new DefaultBackupScheduleArgs
		{
			Namespace = namespaceName,
			Labels = appLabels,
			RepoUrl = resticRepo,
			RepoCredentialsName = resticCredentials.Metadata.Apply(x => x.Name),
			RepoCredentialsKey = "password"
		});
	}
}