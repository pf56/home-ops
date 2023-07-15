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
    /// SelectorTerm matches pairs of nodes by checking that the nodes match all specified requirements.
    /// </summary>
    public class LinstorNodeConnectionSpecSelectorArgs : global::Pulumi.ResourceArgs
    {
        [Input("matchLabels")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecSelectorMatchLabelsArgs>? _matchLabels;

        /// <summary>
        /// MatchLabels is a list of match expressions that the node pairs must meet.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecSelectorMatchLabelsArgs> MatchLabels
        {
            get => _matchLabels ?? (_matchLabels = new InputList<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorNodeConnectionSpecSelectorMatchLabelsArgs>());
            set => _matchLabels = value;
        }

        public LinstorNodeConnectionSpecSelectorArgs()
        {
        }
        public static new LinstorNodeConnectionSpecSelectorArgs Empty => new LinstorNodeConnectionSpecSelectorArgs();
    }
}
