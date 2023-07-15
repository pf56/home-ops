#nullable enable
using System.Collections.Generic;
using Pulumi;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Helm;
using Pulumi.Kubernetes.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;

namespace Rook;

public class Rook : Stack
{
	private const string rookRepo = "https://charts.rook.io/release";
	private const string rookVersion = "1.11.9";

	public Rook()
	{
		Namespace @namespace = new("namespace", new NamespaceArgs
		{
			ApiVersion = "v1",
			Kind = "Namespace",
			Metadata = new ObjectMetaArgs
			{
				Name = "rook-ceph",
				Labels =
				{
					{ "pod-security.kubernetes.io/enforce", "privileged" }
				}
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);

		Release rookOperator = new("rook-ceph", new ReleaseArgs
		{
			Chart = "rook-ceph",
			Version = rookVersion,
			Namespace = namespaceName,
			RepositoryOpts = new RepositoryOptsArgs
			{
				Repo = rookRepo
			}
		});

		Release rookCluster = new("rook-ceph-cluster", new ReleaseArgs
		{
			Chart = "rook-ceph-cluster",
			Version = rookVersion,
			Namespace = namespaceName,
			RepositoryOpts = new RepositoryOptsArgs
			{
				Repo = rookRepo
			},
			Values = new InputMap<object>
			{
				["operatorNamespace"] = namespaceName,
				["cluster"] = new InputMap<object>
				{
					["placement"] = new InputMap<object>
					{
						["all"] = new InputMap<object>
						{
							["nodeAffinity"] = new InputMap<object>
							{
								["requiredDuringSchedulingIgnoredDuringExecution"] = new InputMap<object>
								{
									["nodeSelectorTerms"] = new InputList<object>
									{
										(Input<object>)new InputMap<object>
										{
											["matchExpressions"] = new InputList<object>
											{
												(Input<object>)new InputMap<object>
												{
													["key"] = "paulfriedrich.me/role",
													["operator"] = "In",
													["values"] = new InputList<string>
													{
														"ceph-storage-node"
													}
												}
											}
										}
									}
								}
							},
							["tolerations"] = new InputList<object>
							{
								(Input<object>)new InputMap<object>
								{
									["key"] = "ceph-storage-node",
									["operator"] = "exists"
								}
							}
						}
					},
					["storage"] = new InputMap<object>
					{
						["useAllNodes"] = false,
						["useAllDevices"] = false,
						["nodes"] = new InputList<object>
						{
							(Input<object>)new InputMap<object>
							{
								["name"] = "talosworker01",
								["devices"] = new InputList<object>
								{
									(Input<object>)new InputMap<object>
									{
										["name"] = "/dev/vdb"
									}
								}
							},
							(Input<object>)new InputMap<object>
							{
								["name"] = "talosworker02",
								["devices"] = new InputList<object>
								{
									(Input<object>)new InputMap<object>
									{
										["name"] = "/dev/vdb"
									}
								}
							},
							(Input<object>)new InputMap<object>
							{
								["name"] = "talosworker03",
								["devices"] = new InputList<object>
								{
									(Input<object>)new InputMap<object>
									{
										["name"] = "/dev/vdb"
									}
								}
							}
						}
					}
				},
				["toolbox"] = new InputMap<object>
				{
					["enabled"] = true
				}
			}
		});
	}
}