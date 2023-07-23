// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Crds.K8up.V1
{
    /// <summary>
    /// Snapshot is the Schema for the snapshots API
    /// </summary>
    [CrdsResourceType("kubernetes:k8up.io/v1:Snapshot")]
    public partial class Snapshot : KubernetesResource
    {
        [Output("apiVersion")]
        public Output<string> ApiVersion { get; private set; } = null!;

        [Output("kind")]
        public Output<string> Kind { get; private set; } = null!;

        [Output("metadata")]
        public Output<Pulumi.Kubernetes.Types.Outputs.Meta.V1.ObjectMeta> Metadata { get; private set; } = null!;

        /// <summary>
        /// SnapshotSpec contains all information needed about a restic snapshot so it can be restored.
        /// </summary>
        [Output("spec")]
        public Output<Pulumi.Kubernetes.Types.Outputs.K8up.V1.SnapshotSpec> Spec { get; private set; } = null!;

        /// <summary>
        /// SnapshotStatus defines the observed state of Snapshot
        /// </summary>
        [Output("status")]
        public Output<ImmutableDictionary<string, object>> Status { get; private set; } = null!;


        /// <summary>
        /// Create a Snapshot resource with the given unique name, arguments, and options.
        /// </summary>
        ///
        /// <param name="name">The unique name of the resource</param>
        /// <param name="args">The arguments used to populate this resource's properties</param>
        /// <param name="options">A bag of options that control this resource's behavior</param>
        public Snapshot(string name, Pulumi.Kubernetes.Types.Inputs.K8up.V1.SnapshotArgs? args = null, CustomResourceOptions? options = null)
            : base("kubernetes:k8up.io/v1:Snapshot", name, MakeArgs(args), MakeResourceOptions(options, ""))
        {
        }
        internal Snapshot(string name, ImmutableDictionary<string, object?> dictionary, CustomResourceOptions? options = null)
            : base("kubernetes:k8up.io/v1:Snapshot", name, new DictionaryResourceArgs(dictionary), MakeResourceOptions(options, ""))
        {
        }

        private Snapshot(string name, Input<string> id, CustomResourceOptions? options = null)
            : base("kubernetes:k8up.io/v1:Snapshot", name, null, MakeResourceOptions(options, id))
        {
        }

        private static Pulumi.Kubernetes.Types.Inputs.K8up.V1.SnapshotArgs? MakeArgs(Pulumi.Kubernetes.Types.Inputs.K8up.V1.SnapshotArgs? args)
        {
            args ??= new Pulumi.Kubernetes.Types.Inputs.K8up.V1.SnapshotArgs();
            args.ApiVersion = "k8up.io/v1";
            args.Kind = "Snapshot";
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
        /// Get an existing Snapshot resource's state with the given name, ID, and optional extra
        /// properties used to qualify the lookup.
        /// </summary>
        ///
        /// <param name="name">The unique name of the resulting resource.</param>
        /// <param name="id">The unique provider ID of the resource to lookup.</param>
        /// <param name="options">A bag of options that control this resource's behavior</param>
        public static Snapshot Get(string name, Input<string> id, CustomResourceOptions? options = null)
        {
            return new Snapshot(name, id, options);
        }
    }
}
namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    public class SnapshotArgs : global::Pulumi.ResourceArgs
    {
        [Input("apiVersion")]
        public Input<string>? ApiVersion { get; set; }

        [Input("kind")]
        public Input<string>? Kind { get; set; }

        [Input("metadata")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Meta.V1.ObjectMetaArgs>? Metadata { get; set; }

        /// <summary>
        /// SnapshotSpec contains all information needed about a restic snapshot so it can be restored.
        /// </summary>
        [Input("spec")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.SnapshotSpecArgs>? Spec { get; set; }

        [Input("status")]
        private InputMap<object>? _status;

        /// <summary>
        /// SnapshotStatus defines the observed state of Snapshot
        /// </summary>
        public InputMap<object> Status
        {
            get => _status ?? (_status = new InputMap<object>());
            set => _status = value;
        }

        public SnapshotArgs()
        {
        }
        public static new SnapshotArgs Empty => new SnapshotArgs();
    }
}
