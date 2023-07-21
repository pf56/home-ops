using Pulumi;
using Pulumi.Crds.Traefik.V1Alpha1;
using Pulumi.Kubernetes.Networking.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;
using Pulumi.Kubernetes.Types.Inputs.Networking.V1;
using Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1;

namespace Components;

public class DefaultIngress : ComponentResource
{
	public DefaultIngress(
		string name,
		DefaultIngressArgs args,
		ComponentResourceOptions? options = null
		) : base("homeops:Common:DefaultIngress", name, options)
	{
		Middleware redirectMiddleware = new($"{name}-https-redirect", new MiddlewareArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Namespace = args.Namespace
			},
			Spec = new MiddlewareSpecArgs
			{
				RedirectScheme = new MiddlewareSpecRedirectSchemeArgs
				{
					Scheme = "https",
					Permanent = true
				}
			}
		}, new CustomResourceOptions { Parent = this });

		Ingress ingressHttp = new($"{name}-ingress-http", new IngressArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Namespace = args.Namespace,
				Labels = args.Labels,
				Annotations =
				{
					{ "traefik.ingress.kubernetes.io/router.entrypoints", "web" },
					{
						"traefik.ingress.kubernetes.io/router.middlewares",
						Output.Format(
							$"{args.Namespace}-{redirectMiddleware.Metadata.Apply(x => x.Name)}@kubernetescrd")
					}
				}
			},
			Spec = new IngressSpecArgs
			{
				Rules = args.IngressRules
			}
		}, new CustomResourceOptions { Parent = this });

		Ingress ingress = new($"{name}-ingress-https", new IngressArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Namespace = args.Namespace,
				Labels = args.Labels,
				Annotations =
				{
					{ "traefik.ingress.kubernetes.io/router.entrypoints", "websecure" },
					{ "traefik.ingress.kubernetes.io/router.tls", "true" }
				}
			},
			Spec = new IngressSpecArgs
			{
				Rules = args.IngressRules,
				Tls = args.Tls
			}
		}, new CustomResourceOptions { Parent = this });

		RegisterOutputs();
	}
}

public class DefaultIngressArgs : ResourceArgs
{
	public Input<string> Namespace { get; set; } = null!;
	public InputMap<string> Labels { get; set; } = new();
	public InputList<IngressRuleArgs> IngressRules { get; set; } = null!;
	public InputList<IngressTLSArgs> Tls { get; set; } = null!;
}