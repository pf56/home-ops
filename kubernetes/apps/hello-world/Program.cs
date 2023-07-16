using Pulumi;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Apps.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using System.Collections.Generic;
using Pulumi.Kubernetes.Core.V1;

return await Deployment.RunAsync(() =>
{
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

    var statefulset = new Pulumi.Kubernetes.Apps.V1.StatefulSet("nginx", new StatefulSetArgs
    {
        Metadata = new ObjectMetaArgs
        {
            Namespace = namespaceName
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

    // export the deployment name
    return new Dictionary<string, object?>
    {
        ["name"] =  statefulset.Metadata.Apply(m => m.Name)
    };
});
