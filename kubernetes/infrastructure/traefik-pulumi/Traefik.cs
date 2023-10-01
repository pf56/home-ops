using System;
using Pulumi;
using Pulumi.Crds.Certmanager.V1;
using Pulumi.Crds.Traefik.V1Alpha1;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Certmanager.V1;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1;

namespace Traefik;

public class Traefik : Stack
{
	private const string repo = "https://traefik.github.io/charts/";
	private const string version = "23.1.0";

	public Traefik()
	{
		Namespace @namespace = new("namespace", new NamespaceArgs
		{
			ApiVersion = "v1",
			Kind = "Namespace",
			Metadata = new ObjectMetaArgs
			{
				Name = "traefik"
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);

		Release traefikIngress = new("traefik-ingress", new ReleaseArgs
		{
			Chart = "traefik",
			Version = version,
			Namespace = namespaceName,
			RepositoryOpts = new RepositoryOptsArgs
			{
				Repo = repo
			},
			Values = new InputMap<object>
			{
				["service"] = new InputMap<object>
				{
					["annotations"] = new InputMap<object>
					{
						["io.cilium/lb-ipam-ips"] = "172.16.61.1"
					}
				},
				["providers"] = new InputMap<object>
				{
					["kubernetesIngress"] = new InputMap<object>
					{
						["publishedService"] = new InputMap<object>
						{
							["enabled"] = true
						}
					}
				}
			}
		});

		StackReference certManager = new("pfriedrich/cert-manager/prod");
		var clusterIssuerName = certManager.GetOutput("ClusterIssuerName").Apply(x =>
		{
			string? value = x?.ToString();

			if(string.IsNullOrEmpty(value))
				throw new Exception("Missing ClusterIssuer");

			return value;
		});

		Certificate wildcardCertificate = new("wildcard-internal-paulfriedrich-me", new CertificateArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Namespace = namespaceName
			},
			Spec = new CertificateSpecArgs
			{
				SecretName = "wildcard-internal-paulfriedrich-me-tls",
				IssuerRef = new CertificateSpecIssuerRefArgs
				{
					Name = clusterIssuerName,
					Kind = "ClusterIssuer"
				},
				DnsNames =
				{
					"*.internal.paulfriedrich.me"
				}
			}
		});

		TLSStore tlsStore = new("default-tls-store", new TLSStoreArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Name = "default",
				Namespace = namespaceName
			},
			Spec = new TLSStoreSpecArgs
			{
				DefaultCertificate = new TLSStoreSpecDefaultCertificateArgs
				{
					SecretName = wildcardCertificate.Spec.Apply(x => x.SecretName)
				}
			}
		});
	}
}