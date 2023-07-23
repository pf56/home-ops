using Pulumi;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Yaml;

namespace K8Up;

public class K8Up : Stack
{
	private const string repo = "https://k8up-io.github.io/k8up";
	private const string version = "4.3.0";

	public K8Up()
	{
		Namespace @namespace = new("namespace", new NamespaceArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "k8up"
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);

		ConfigFile crds = new("k8up-crds", new ConfigFileArgs
		{
			File = $"./k8up-{version}-crd.yaml"
		});

		Release k8up = new("k8up", new ReleaseArgs
		{
			Chart = "k8up",
			Version = version,
			Namespace = namespaceName,
			RepositoryOpts = new RepositoryOptsArgs
			{
				Repo = repo
			},
			Values = new InputMap<object>
			{
				["k8up"] = new InputMap<object>
				{
					["envVars"] = new InputList<object>
					{
						(Input<object>)new InputMap<object>
						{
							["name"] = "BACKUP_GLOBAL_OPERATOR_NAMESPACE",
							["value"] = namespaceName
						}
					}
				}
			}
		});
	}
}