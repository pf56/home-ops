// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.Piraeus.V1
{

    /// <summary>
    /// Target points to the resources that the patch is applied to
    /// </summary>
    public class LinstorSatelliteSpecPatchesTargetArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// AnnotationSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches against the resource annotations.
        /// </summary>
        [Input("annotationSelector")]
        public Input<string>? AnnotationSelector { get; set; }

        [Input("group")]
        public Input<string>? Group { get; set; }

        [Input("kind")]
        public Input<string>? Kind { get; set; }

        /// <summary>
        /// LabelSelector is a string that follows the label selection expression https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#api It matches against the resource labels.
        /// </summary>
        [Input("labelSelector")]
        public Input<string>? LabelSelector { get; set; }

        /// <summary>
        /// Name of the resource.
        /// </summary>
        [Input("name")]
        public Input<string>? Name { get; set; }

        /// <summary>
        /// Namespace the resource belongs to, if it can belong to a namespace.
        /// </summary>
        [Input("namespace")]
        public Input<string>? Namespace { get; set; }

        [Input("version")]
        public Input<string>? Version { get; set; }

        public LinstorSatelliteSpecPatchesTargetArgs()
        {
        }
        public static new LinstorSatelliteSpecPatchesTargetArgs Empty => new LinstorSatelliteSpecPatchesTargetArgs();
    }
}
