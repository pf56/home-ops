// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.Piraeus.V1
{

    public class LinstorNodeConnectionSpecPathsArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Interface to use on both nodes.
        /// </summary>
        [Input("interface", required: true)]
        public Input<string> Interface { get; set; } = null!;

        /// <summary>
        /// Name of the path.
        /// </summary>
        [Input("name", required: true)]
        public Input<string> Name { get; set; } = null!;

        public LinstorNodeConnectionSpecPathsArgs()
        {
        }
        public static new LinstorNodeConnectionSpecPathsArgs Empty => new LinstorNodeConnectionSpecPathsArgs();
    }
}