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
    /// LinstorNodeConnectionSpec defines the desired state of LinstorNodeConnection
    /// </summary>
    public class LinstorNodeConnectionSpecArgs : global::Pulumi.ResourceArgs
    {
        [Input("paths")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecPathsArgs>? _paths;

        /// <summary>
        /// Paths configure the network path used when connecting two nodes.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecPathsArgs> Paths
        {
            get => _paths ?? (_paths = new InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecPathsArgs>());
            set => _paths = value;
        }

        [Input("properties")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecPropertiesArgs>? _properties;

        /// <summary>
        /// Properties to apply for the node connection. 
        ///  Use to create default settings for DRBD that should apply to all resources connections between a set of cluster nodes.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecPropertiesArgs> Properties
        {
            get => _properties ?? (_properties = new InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecPropertiesArgs>());
            set => _properties = value;
        }

        [Input("selector")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecSelectorArgs>? _selector;

        /// <summary>
        /// Selector selects which pair of Satellites the connection should apply to. If not given, the connection will be applied to all connections.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecSelectorArgs> Selector
        {
            get => _selector ?? (_selector = new InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecSelectorArgs>());
            set => _selector = value;
        }

        public LinstorNodeConnectionSpecArgs()
        {
        }
        public static new LinstorNodeConnectionSpecArgs Empty => new LinstorNodeConnectionSpecArgs();
    }
}
