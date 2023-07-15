// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Crds.Piraeus.V1
{
    /// <summary>
    /// LinstorSatelliteConfiguration is the Schema for the linstorsatelliteconfigurations API
    /// </summary>
    [CrdsResourceType("kubernetes:piraeus.io/v1:LinstorSatelliteConfiguration")]
    public partial class LinstorSatelliteConfiguration : KubernetesResource
    {
        [Output("apiVersion")]
        public Output<string> ApiVersion { get; private set; } = null!;

        [Output("kind")]
        public Output<string> Kind { get; private set; } = null!;

        [Output("metadata")]
        public Output<Pulumi.Kubernetes.Types.Outputs.Meta.V1.ObjectMeta> Metadata { get; private set; } = null!;

        /// <summary>
        /// LinstorSatelliteConfigurationSpec defines a partial, desired state of a LinstorSatelliteSpec. 
        ///  All the LinstorSatelliteConfiguration resources with matching NodeSelector will be merged into a single LinstorSatelliteSpec.
        /// </summary>
        [Output("spec")]
        public Output<Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationSpec> Spec { get; private set; } = null!;

        /// <summary>
        /// LinstorSatelliteConfigurationStatus defines the observed state of LinstorSatelliteConfiguration
        /// </summary>
        [Output("status")]
        public Output<Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorSatelliteConfigurationStatus> Status { get; private set; } = null!;


        /// <summary>
        /// Create a LinstorSatelliteConfiguration resource with the given unique name, arguments, and options.
        /// </summary>
        ///
        /// <param name="name">The unique name of the resource</param>
        /// <param name="args">The arguments used to populate this resource's properties</param>
        /// <param name="options">A bag of options that control this resource's behavior</param>
        public LinstorSatelliteConfiguration(string name, Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteConfigurationArgs? args = null, CustomResourceOptions? options = null)
            : base("kubernetes:piraeus.io/v1:LinstorSatelliteConfiguration", name, MakeArgs(args), MakeResourceOptions(options, ""))
        {
        }
        internal LinstorSatelliteConfiguration(string name, ImmutableDictionary<string, object?> dictionary, CustomResourceOptions? options = null)
            : base("kubernetes:piraeus.io/v1:LinstorSatelliteConfiguration", name, new DictionaryResourceArgs(dictionary), MakeResourceOptions(options, ""))
        {
        }

        private LinstorSatelliteConfiguration(string name, Input<string> id, CustomResourceOptions? options = null)
            : base("kubernetes:piraeus.io/v1:LinstorSatelliteConfiguration", name, null, MakeResourceOptions(options, id))
        {
        }

        private static Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteConfigurationArgs? MakeArgs(Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteConfigurationArgs? args)
        {
            args ??= new Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteConfigurationArgs();
            args.ApiVersion = "piraeus.io/v1";
            args.Kind = "LinstorSatelliteConfiguration";
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
        /// Get an existing LinstorSatelliteConfiguration resource's state with the given name, ID, and optional extra
        /// properties used to qualify the lookup.
        /// </summary>
        ///
        /// <param name="name">The unique name of the resulting resource.</param>
        /// <param name="id">The unique provider ID of the resource to lookup.</param>
        /// <param name="options">A bag of options that control this resource's behavior</param>
        public static LinstorSatelliteConfiguration Get(string name, Input<string> id, CustomResourceOptions? options = null)
        {
            return new LinstorSatelliteConfiguration(name, id, options);
        }
    }
}
namespace Pulumi.Kubernetes.Types.Inputs.Piraeus.V1
{

    public class LinstorSatelliteConfigurationArgs : global::Pulumi.ResourceArgs
    {
        [Input("apiVersion")]
        public Input<string>? ApiVersion { get; set; }

        [Input("kind")]
        public Input<string>? Kind { get; set; }

        [Input("metadata")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Meta.V1.ObjectMetaArgs>? Metadata { get; set; }

        /// <summary>
        /// LinstorSatelliteConfigurationSpec defines a partial, desired state of a LinstorSatelliteSpec. 
        ///  All the LinstorSatelliteConfiguration resources with matching NodeSelector will be merged into a single LinstorSatelliteSpec.
        /// </summary>
        [Input("spec")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteConfigurationSpecArgs>? Spec { get; set; }

        /// <summary>
        /// LinstorSatelliteConfigurationStatus defines the observed state of LinstorSatelliteConfiguration
        /// </summary>
        [Input("status")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteConfigurationStatusArgs>? Status { get; set; }

        public LinstorSatelliteConfigurationArgs()
        {
        }
        public static new LinstorSatelliteConfigurationArgs Empty => new LinstorSatelliteConfigurationArgs();
    }
}
