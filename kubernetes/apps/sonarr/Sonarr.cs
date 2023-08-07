using System.Linq;
using Components;
using Pulumi;
using Pulumi.Kubernetes.Apps.V1;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Apps.V1;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Types.Inputs.Networking.V1;

namespace Sonarr;

public class Sonarr : Stack
{
	public Sonarr()
	{
		Config config = new();
		var resticRepo = config.Require("restic-repo");
		var resticPassword = config.RequireSecret("restic-password");

		string imageName = "linuxserver/sonarr";
		string imageTag = "develop-version-4.0.0.575";

		Namespace @namespace = new("sonarr", new NamespaceArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "sonarr"
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);
		InputMap<string> appLabels = new()
		{
			{ "app", "sonarr" }
		};

		PersistentVolume pvDownloads = new("pv-sonarr-downloads", new PersistentVolumeArgs
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
					VolumeHandle = "sonarr#storage.internal.paulfriedrich.me/mnt/tank/downloads",
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

		PersistentVolume pvTv = new("pv-sonarr-tv", new PersistentVolumeArgs
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
					VolumeHandle = "sonarr#storage.internal.paulfriedrich.me/mnt/tank/tv",
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

		PersistentVolumeClaim pvcDownloads = new("pvc-sonarr-downloads",
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

		PersistentVolumeClaim pvcTv = new("pvc-sonarr-tv",
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

		Service service = new("sonarr", new ServiceArgs
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

		StatefulSet sonarr = new("sonarr", new StatefulSetArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "sonarr",
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
								Name = "sonarr",
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
										ContainerPortValue = 8989,
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
										MountPath = "/tv",
										Name = "tv"
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
									ClaimName = pvcDownloads.Metadata.Apply(x => x.Name)
								}
							},
							new VolumeArgs
							{
								Name = "tv",
								PersistentVolumeClaim = new PersistentVolumeClaimVolumeSourceArgs
								{
									ClaimName = pvcTv.Metadata.Apply(x => x.Name)
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
					}
				}
			}
		}, new CustomResourceOptions { DeleteBeforeReplace = true });

		DefaultIngress ingress = new("sonarr", new DefaultIngressArgs
		{
			Namespace = namespaceName,
			Labels = appLabels,
			IngressRules = new InputList<IngressRuleArgs>
			{
				new IngressRuleArgs
				{
					Host = "sonarr.internal.paulfriedrich.me",
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
					"sonarr.internal.paulfriedrich.me"
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