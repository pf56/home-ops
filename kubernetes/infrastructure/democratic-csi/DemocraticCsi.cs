#nullable enable
using Pulumi;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;

namespace DemocraticCsi;

public class DemocraticCsi : Stack
{
	private const string repo = "https://democratic-csi.github.io/charts/";
	private const string version = "0.13.7";

	public DemocraticCsi()
	{
		Config config = new();
		Output<string> apiKey = config.RequireSecret("truenas-api-key");
		string iscsiUsername = config.Require("iscsi-username");
		Output<string> iscsiPassword = config.RequireSecret("iscsi-password");
		string iscsiUsernameIn = config.Require("iscsi-username-in");
		Output<string> iscsiPasswordIn = config.RequireSecret("iscsi-password-in");

		Namespace @namespace = new("namespace", new NamespaceArgs
		{
			ApiVersion = "v1",
			Kind = "Namespace",
			Metadata = new ObjectMetaArgs
			{
				Name = "democratic-csi",
				Labels =
				{
					{ "pod-security.kubernetes.io/enforce", "privileged" }
				}
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);

		Release freenasApiIscsi = new("freenas-api-iscsi", new ReleaseArgs
		{
			Chart = "democratic-csi",
			Version = version,
			Namespace = namespaceName,
			RepositoryOpts = new RepositoryOptsArgs
			{
				Repo = repo
			},
			Values = new InputMap<object>
			{
				["node"] = new InputMap<object>
				{
					["hostPID"] = true,
					["driver"] = new InputMap<object>
					{
						["extraEnv"] = new InputList<object>
						{
							(Input<object>)new InputMap<object>
							{
								["name"] = "ISCSIADM_HOST_STRATEGY",
								["value"] = "nsenter"
							},
							(Input<object>)new InputMap<object>
							{
								["name"] = "ISCSIADM_HOST_PATH",
								["value"] = "/usr/local/sbin/iscsiadm"
							}
						},
						["iscsiDirHostPath"] = "/usr/local/etc/iscsi",
						["iscsiDirHostPathType"] = ""
					}
				},
				["csiDriver"] = new InputMap<object>
				{
					["name"] = "org.democratic-csi.freenas-api-iscsi"
				},
				["storageClasses"] = new InputList<object>
				{
					(Input<object>)new InputMap<object>
					{
						["name"] = "freenas-api-iscsi-csi",
						["defaultClass"] = false,
						["reclaimPolicy"] = "Delete",
						["volumeBindingMode"] = "Immediate",
						["allowVolumeExpansion"] = true,
						["parameters"] = new InputMap<object>
						{
							["fsType"] = "ext4"
						},
						["mountOptions"] = new InputList<object>(),
						["secrets"] = new InputMap<object>
						{
							["node-stage-secret"] = new InputMap<object>
							{
								// CHAP
								["node-db.node.session.auth.authmethod"] = "CHAP",
								["node-db.node.session.auth.username"] = iscsiUsername,
								["node-db.node.session.auth.password"] = iscsiPassword,

								// mutual CHAP
								["node-db.node.session.auth.username_in"] = iscsiUsernameIn,
								["node-db.node.session.auth.password_in"] = iscsiPasswordIn
							}
						}
					}
				},
				["volumeSnapshotClasses"] = new InputList<object>(),
				["driver"] = new InputMap<object>
				{
					["config"] = new InputMap<object>
					{
						["driver"] = "freenas-api-iscsi",
						["httpConnection"] = new InputMap<object>
						{
							["protocol"] = "https",
							["host"] = "storage.internal.paulfriedrich.me",
							["port"] = "443",
							["apiKey"] = apiKey,
							["allowInsecure"] = false
						},
						["zfs"] = new InputMap<object>
						{
							["datasetProperties"] = new InputMap<object>
							{
								["org.freenas:description"] =
									"{{ parameters.[csi.storage.k8s.io/pvc/namespace] }}/{{ parameters.[csi.storage.k8s.io/pvc/name] }}"
							},
							["datasetParentName"] = "local/k8s/volumes",
							["detachedSnapshotsDatasetParentName"] = "local/k8s/snapshots",
							["zvolEnableReservation"] = false
						},
						["iscsi"] = new InputMap<object>
						{
							["targetPortal"] = "10.0.60.3:3260",
							["nameTemplate"] =
								"{{ parameters.[csi.storage.k8s.io/pvc/namespace] }}-{{ parameters.[csi.storage.k8s.io/pvc/name] }}",
							["namePrefix"] = "csi-",
							["targetGroups"] = new InputList<object>
							{
								(Input<object>)new InputMap<object>
								{
									["targetGroupPortalGroup"] = 2,
									["targetGroupInitiatorGroup"] = 1,
									["targetGroupAuthType"] = "CHAP Mutual",
									["targetGroupAuthGroup"] = 1
								}
							},
							["extentInsecureTpc"] = true,
							["extentXenCompat"] = false,
							["extentDisablePhysicalBlocksize"] = true,
							["extentBlocksize"] = 512,
							["extentRpm"] = "SSD",
							["extentAvailThreshold"] = 80
						}
					}
				}
			}
		});
	}
}