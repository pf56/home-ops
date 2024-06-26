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
    /// Schedule is the Schema for the schedules API
    /// </summary>
    [CrdsResourceType("kubernetes:k8up.io/v1:Schedule")]
    public partial class Schedule : KubernetesResource
    {
        [Output("apiVersion")]
        public Output<string> ApiVersion { get; private set; } = null!;

        [Output("kind")]
        public Output<string> Kind { get; private set; } = null!;

        [Output("metadata")]
        public Output<Pulumi.Kubernetes.Types.Outputs.Meta.V1.ObjectMeta> Metadata { get; private set; } = null!;

        /// <summary>
        /// ScheduleSpec defines the schedules for the various job types.
        /// </summary>
        [Output("spec")]
        public Output<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpec> Spec { get; private set; } = null!;

        /// <summary>
        /// ScheduleStatus defines the observed state of Schedule
        /// </summary>
        [Output("status")]
        public Output<Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleStatus> Status { get; private set; } = null!;


        /// <summary>
        /// Create a Schedule resource with the given unique name, arguments, and options.
        /// </summary>
        ///
        /// <param name="name">The unique name of the resource</param>
        /// <param name="args">The arguments used to populate this resource's properties</param>
        /// <param name="options">A bag of options that control this resource's behavior</param>
        public Schedule(string name, Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleArgs? args = null, CustomResourceOptions? options = null)
            : base("kubernetes:k8up.io/v1:Schedule", name, MakeArgs(args), MakeResourceOptions(options, ""))
        {
        }
        internal Schedule(string name, ImmutableDictionary<string, object?> dictionary, CustomResourceOptions? options = null)
            : base("kubernetes:k8up.io/v1:Schedule", name, new DictionaryResourceArgs(dictionary), MakeResourceOptions(options, ""))
        {
        }

        private Schedule(string name, Input<string> id, CustomResourceOptions? options = null)
            : base("kubernetes:k8up.io/v1:Schedule", name, null, MakeResourceOptions(options, id))
        {
        }

        private static Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleArgs? MakeArgs(Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleArgs? args)
        {
            args ??= new Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleArgs();
            args.ApiVersion = "k8up.io/v1";
            args.Kind = "Schedule";
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
        /// Get an existing Schedule resource's state with the given name, ID, and optional extra
        /// properties used to qualify the lookup.
        /// </summary>
        ///
        /// <param name="name">The unique name of the resulting resource.</param>
        /// <param name="id">The unique provider ID of the resource to lookup.</param>
        /// <param name="options">A bag of options that control this resource's behavior</param>
        public static Schedule Get(string name, Input<string> id, CustomResourceOptions? options = null)
        {
            return new Schedule(name, id, options);
        }
    }
}
namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    public class ScheduleArgs : global::Pulumi.ResourceArgs
    {
        [Input("apiVersion")]
        public Input<string>? ApiVersion { get; set; }

        [Input("kind")]
        public Input<string>? Kind { get; set; }

        [Input("metadata")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Meta.V1.ObjectMetaArgs>? Metadata { get; set; }

        /// <summary>
        /// ScheduleSpec defines the schedules for the various job types.
        /// </summary>
        [Input("spec")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleSpecArgs>? Spec { get; set; }

        /// <summary>
        /// ScheduleStatus defines the observed state of Schedule
        /// </summary>
        [Input("status")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleStatusArgs>? Status { get; set; }

        public ScheduleArgs()
        {
        }
        public static new ScheduleArgs Empty => new ScheduleArgs();
    }
}
