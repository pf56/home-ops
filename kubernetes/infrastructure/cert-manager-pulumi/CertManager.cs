#nullable enable
using Pulumi;
using Pulumi.Crds.Certmanager.V1;
using Pulumi.Kubernetes.Core.V1;
using Pulumi.Kubernetes.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Certmanager.V1;
using Pulumi.Kubernetes.Types.Inputs.Core.V1;
using Pulumi.Kubernetes.Types.Inputs.Helm.V3;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;

namespace CertManager;

public class CertManager : Stack
{
	private const string repo = "https://charts.jetstack.io";
	private const string version = "1.12.2";

	public CertManager()
	{
		Config config = new();
		string email = config.Require("cloudflare-email");
		Output<string> apiToken = config.RequireSecret("cloudflare-api-token");

		Namespace @namespace = new("namespace", new NamespaceArgs
		{
			ApiVersion = "v1",
			Kind = "Namespace",
			Metadata = new ObjectMetaArgs
			{
				Name = "cert-manager"
			}
		});

		Output<string> namespaceName = @namespace.Metadata.Apply(x => x.Name);

		Release certManager = new("cert-manager", new ReleaseArgs
		{
			Chart = "cert-manager",
			Version = version,
			Namespace = namespaceName,
			RepositoryOpts = new RepositoryOptsArgs
			{
				Repo = repo
			},
			Values =
			{
				["installCRDs"] = true,
				["dns01RecursiveNameservers"] = "1.1.1.1:53,9.9.9.9:53",
				["dns01RecursiveNameserversOnly"] = true
			}
		});

		Secret cloudflareApiToken = new("cloudflare-api-token", new SecretArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Namespace = namespaceName
			},
			Type = "Opaque",
			StringData =
			{
				["api-token"] = apiToken
			}
		});

		 ClusterIssuer clusterIssuer = new("letsencrypt", new ClusterIssuerArgs
		 {
		 	Metadata = new ObjectMetaArgs
		 	{
		 		Namespace = namespaceName
		 	},
		 	Spec = new ClusterIssuerSpecArgs
		 	{
		 		Acme = new ClusterIssuerSpecAcmeArgs
		 		{
		 			Server = "https://acme-v02.api.letsencrypt.org/directory",
		 			Email = email,
		 			PrivateKeySecretRef = new ClusterIssuerSpecAcmePrivateKeySecretRefArgs
		 			{
		 				Name = "letsencrypt-key"
		 			},
		 			Solvers =
		 			{
		 				new ClusterIssuerSpecAcmeSolversArgs
		 				{
		 					Dns01 = new ClusterIssuerSpecAcmeSolversDns01Args
		 					{
		 						Cloudflare = new ClusterIssuerSpecAcmeSolversDns01CloudflareArgs
		 						{
		 							Email = email,
		 							ApiTokenSecretRef = new ClusterIssuerSpecAcmeSolversDns01CloudflareApiTokenSecretRefArgs
		 							{
		 								Name = cloudflareApiToken.Metadata.Apply(x => x.Name),
		 								Key = "api-token"
		 							}
		 						}
		 					}
		 				}
		 			}
		 		}
		 	}
		 });

		ClusterIssuerName = clusterIssuer.Metadata.Apply(x => x.Name);
	}

	[Output]
	public Output<string> ClusterIssuerName { get; set; }
}