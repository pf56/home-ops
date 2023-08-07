using Pulumi;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Apps.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using System.Collections.Generic;
using Components;
using Pulumi.Kubernetes.Core.V1;
using Namespace = Pulumi.Kubernetes.Core.V1.Namespace;

return await Deployment.RunAsync(() =>
{
    Config config = new();
    var resticRepo = config.RequireSecret("restic-repo");
    var resticPassword = config.RequireSecret("restic-password");

    Namespace @namespace = new("hello-world", new NamespaceArgs
    {
        ApiVersion = "v1",
        Kind = "Namespace",
        Metadata = new ObjectMetaArgs
        {
            Name = "hello-world"
        }
    });

    Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);

    var appLabels = new InputMap<string>
    {
        { "app", "nginx" }
    };

    var service = new Pulumi.Kubernetes.Core.V1.Service("service", new ServiceArgs
    {
        Metadata = new ObjectMetaArgs
        {
            Namespace = namespaceName
        },
        Spec = new ServiceSpecArgs
        {
            Type = ServiceSpecType.LoadBalancer,
            Selector = appLabels,
            Ports =
            {
                new ServicePortArgs
                {
                    Protocol = "TCP",
                    Port = 8076,
                    TargetPort = 80
                }
            }
        }
    });

    var statefulset = new Pulumi.Kubernetes.Apps.V1.StatefulSet("nginx", new StatefulSetArgs
    {
        Metadata = new ObjectMetaArgs
        {
            Namespace = namespaceName,
            Annotations =
            {
                //{"k8up.io/backup", "true"}
            }
        },
        Spec = new StatefulSetSpecArgs
        {
            Selector = new LabelSelectorArgs
            {
                MatchLabels = appLabels
            },
            ServiceName = "hello-world-service",
            Replicas = 1,
            Template = new PodTemplateSpecArgs
            {
                Metadata = new ObjectMetaArgs
                {
                    Namespace = namespaceName,
                    Labels = appLabels
                },
                Spec = new PodSpecArgs
                {
                    RestartPolicy = "Always",
                    Containers =
                    {
                        new ContainerArgs
                        {
                            Name = "nginx",
                            Image = "nginx",
                            Ports =
                            {
                                new ContainerPortArgs
                                {
                                    ContainerPortValue = 80
                                }
                            },
                            VolumeMounts =
                            {
                                new VolumeMountArgs
                                {
                                    Name = "rook-volume",
                                    MountPath = "/mnt/rook"
                                }
                            }
                        }
                    }
                }
            },
            VolumeClaimTemplates = new PersistentVolumeClaimArgs
            {
                Metadata = new ObjectMetaArgs
                {
                    Name = "rook-volume"
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

    DefaultBackupSchedule backupSchedule = new("hello-world", new DefaultBackupScheduleArgs
    {
        Namespace = namespaceName,
        Labels = appLabels,
        RepoUrl = resticRepo,
        RepoCredentialsName = resticCredentials.Metadata.Apply(x => x.Name),
        RepoCredentialsKey = "password"
    });

    // export the deployment name
    return new Dictionary<string, object?>
    {
        ["name"] =  statefulset.Metadata.Apply(m => m.Name)
    };
});
