using System.Linq;
using Components;
using Pulumi;
using Pulumi.Kubernetes.Apps.V1;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Apps.V1;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Types.Inputs.Networking.V1;
using Deployment = Pulumi.Kubernetes.Apps.V1.Deployment;

namespace Paperless;

public class Paperless : Stack
{
	public Paperless()
	{
		string imageName = "ghcr.io/paperless-ngx/paperless-ngx";
		string imageTag = "1.16.5";

		Namespace @namespace = new("paperless", new NamespaceArgs
		{
			ApiVersion = "v1",
			Kind = "Namespace",
			Metadata = new ObjectMetaArgs
			{
				Name = "paperless"
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);
		InputMap<string> appLabels = new()
		{
			{ "app", "paperless" }
		};

		Service serviceRedis = new("redis", new ServiceArgs
		{
			ApiVersion = "v1",
			Kind = "Service",
			Metadata = new ObjectMetaArgs
			{
				Namespace = namespaceName,
				Labels =
				{
					{ "app", "redis" }
				},
				Annotations =
				{
					{
						"pulumi.com/skipAwait", "true"
					} // https://github.com/pulumi/pulumi-kubernetes/issues/1995
				}
			},
			Spec = new ServiceSpecArgs
			{
				Selector =
				{
					{ "app", "redis" }
				},
				Ports = new[]
				{
					new ServicePortArgs
					{
						Name = "redis",
						Port = 6379,
						Protocol = "TCP",
						TargetPort = "redis"
					}
				}
			}
		});

		Deployment redis = new("redis", new DeploymentArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Namespace = namespaceName,
				Labels =
				{
					{ "app", "redis" }
				}
			},
			Spec = new DeploymentSpecArgs
			{
				Replicas = 1,
				Selector = new LabelSelectorArgs
				{
					MatchLabels =
					{
						{ "app", "redis" }
					}
				},
				Template = new PodTemplateSpecArgs
				{
					Metadata = new ObjectMetaArgs
					{
						Namespace = namespaceName,
						Labels = { { "app", "redis" } }
					},
					Spec = new PodSpecArgs
					{
						Containers =
						{
							new ContainerArgs
							{
								Name = "redis",
								Image = "docker.io/library/redis:7",
								Ports =
								{
									new ContainerPortArgs
									{
										Name = "redis",
										Protocol = "TCP",
										ContainerPortValue = 6379
									}
								}
							}
						}
					}
				}
			}
		});

		Service service = new("paperless", new ServiceArgs
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

		StatefulSet paperless = new("paperless", new StatefulSetArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "paperless",
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
								Name = "paperless",
								Image = $"{imageName}:{imageTag}",
								Env =
								{
									new EnvVarArgs
									{
										Name = "USERMAP_UID",
										Value = "1001"
									},
									new EnvVarArgs
									{
										Name = "USERMAP_GID",
										Value = "1001"
									},
									new EnvVarArgs
									{
										Name = "PAPERLESS_URL",
										Value = "https://paperless.internal.paulfriedrich.me"
									},
									new EnvVarArgs
									{
										Name = "PAPERLESS_REDIS",
										Value = Output.Format(
											$@"redis://{serviceRedis.Spec.Apply(x => x.ClusterIP)}:6379")
									},
									new EnvVarArgs
									{
										Name = "PAPERLESS_OCR_LANGUAGE",
										Value = "deu"
									},
									new EnvVarArgs
									{
										Name = "PAPERLESS_TIME_ZONE",
										Value = "Europe/Berlin"
									}
								},
								Ports = new[]
								{
									new ContainerPortArgs
									{
										ContainerPortValue = 8000,
										Name = "web-ui",
										Protocol = "TCP"
									}
								},
								VolumeMounts = new[]
								{
									new VolumeMountArgs
									{
										MountPath = "/usr/src/paperless/data",
										Name = "data",
										SubPath = "data"
									},
									new VolumeMountArgs
									{
										MountPath = "/usr/src/paperless/media",
										Name = "data",
										SubPath = "media"
									},
									new VolumeMountArgs
									{
										MountPath = "/usr/src/paperless/export",
										Name = "data",
										SubPath = "export"
									},
									new VolumeMountArgs
									{
										MountPath = "/usr/src/paperless/consume",
										Name = "data",
										SubPath = "consume"
									}
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
									{ "storage", "32Gi" }
								}
							}
						}
					}
				}
			}
		}, new CustomResourceOptions { DeleteBeforeReplace = true, Protect = true });

		DefaultIngress ingress = new DefaultIngress("paperless", new DefaultIngressArgs
		{
			Namespace = namespaceName,
			Labels = appLabels,
			IngressRules = new[]
			{
				new IngressRuleArgs
				{
					Host = "paperless.internal.paulfriedrich.me",
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
			Tls = new[]
			{
				new IngressTLSArgs
				{
					Hosts = new[]
					{
						"paperless.internal.paulfriedrich.me"
					}
				}
			}
		});
	}
}