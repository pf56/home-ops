// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Crds.Traefik.V1Alpha1
{
    /// <summary>
    /// IngressRoute is the CRD implementation of a Traefik HTTP Router.
    /// </summary>
    [CrdsResourceType("kubernetes:traefik.io/v1alpha1:IngressRoute")]
    public partial class IngressRoute : KubernetesResource
    {
        [Output("apiVersion")]
        public Output<string> ApiVersion { get; private set; } = null!;

        [Output("kind")]
        public Output<string> Kind { get; private set; } = null!;

        [Output("metadata")]
        public Output<Pulumi.Kubernetes.Types.Outputs.Meta.V1.ObjectMeta> Metadata { get; private set; } = null!;

        /// <summary>
        /// IngressRouteSpec defines the desired state of IngressRoute.
        /// </summary>
        [Output("spec")]
        public Output<Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.IngressRouteSpec> Spec { get; private set; } = null!;


        /// <summary>
        /// Create a IngressRoute resource with the given unique name, arguments, and options.
        /// </summary>
        ///
        /// <param name="name">The unique name of the resource</param>
        /// <param name="args">The arguments used to populate this resource's properties</param>
        /// <param name="options">A bag of options that control this resource's behavior</param>
        public IngressRoute(string name, Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteArgs? args = null, CustomResourceOptions? options = null)
            : base("kubernetes:traefik.io/v1alpha1:IngressRoute", name, MakeArgs(args), MakeResourceOptions(options, ""))
        {
        }
        internal IngressRoute(string name, ImmutableDictionary<string, object?> dictionary, CustomResourceOptions? options = null)
            : base("kubernetes:traefik.io/v1alpha1:IngressRoute", name, new DictionaryResourceArgs(dictionary), MakeResourceOptions(options, ""))
        {
        }

        private IngressRoute(string name, Input<string> id, CustomResourceOptions? options = null)
            : base("kubernetes:traefik.io/v1alpha1:IngressRoute", name, null, MakeResourceOptions(options, id))
        {
        }

        private static Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteArgs? MakeArgs(Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteArgs? args)
        {
            args ??= new Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteArgs();
            args.ApiVersion = "traefik.io/v1alpha1";
            args.Kind = "IngressRoute";
            return args;
        }

        private static CustomResourceOptions MakeResourceOptions(CustomResourceOptions? options, Input<string>? id)
        {
            var defaultOptions = new CustomResourceOptions
            {
                Version = Utilities.Version,
            };
            var merged = CustomResourceOptions.Merge(defaultOptions, options);
            // Override the ID if one was specified for consistency with other language SDKs.
            merged.Id = id ?? merged.Id;
            return merged;
        }
        /// <summary>
        /// Get an existing IngressRoute resource's state with the given name, ID, and optional extra
        /// properties used to qualify the lookup.
        /// </summary>
        ///
        /// <param name="name">The unique name of the resulting resource.</param>
        /// <param name="id">The unique provider ID of the resource to lookup.</param>
        /// <param name="options">A bag of options that control this resource's behavior</param>
        public static IngressRoute Get(string name, Input<string> id, CustomResourceOptions? options = null)
        {
            return new IngressRoute(name, id, options);
        }
    }
}
namespace Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1
{

    public class IngressRouteArgs : global::Pulumi.ResourceArgs
    {
        [Input("apiVersion")]
        public Input<string>? ApiVersion { get; set; }

        [Input("kind")]
        public Input<string>? Kind { get; set; }

        [Input("metadata")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Meta.V1.ObjectMetaArgs>? Metadata { get; set; }

        /// <summary>
        /// IngressRouteSpec defines the desired state of IngressRoute.
        /// </summary>
        [Input("spec")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteSpecArgs>? Spec { get; set; }

        public IngressRouteArgs()
        {
        }
        public static new IngressRouteArgs Empty => new IngressRouteArgs();
    }
}
