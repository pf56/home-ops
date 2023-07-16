// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.Piraeus.V1
{

    public class LinstorNodeConnectionSpecSelectorMatchLabelsArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Key is the name of a node label.
        /// </summary>
        [Input("key", required: true)]
        public Input<string> Key { get; set; } = null!;

        /// <summary>
        /// Op to apply to the label. Exists (default) checks for the presence of the label on both nodes in the pair. DoesNotExist checks that the label is not present on either node in the pair. In checks for the presence of the label value given by Values on both nodes in the pair. NotIn checks that both nodes in the pair do not have any of the label values given by Values. Same checks that the label value is equal in the node pair. NotSame checks that the label value is not equal in the node pair.
        /// </summary>
        [Input("op")]
        public Input<string>? Op { get; set; }

        [Input("values")]
        private InputList<string>? _values;

        /// <summary>
        /// Values to match on, using the provided Op.
        /// </summary>
        public InputList<string> Values
        {
            get => _values ?? (_values = new InputList<string>());
            set => _values = value;
        }

        public LinstorNodeConnectionSpecSelectorMatchLabelsArgs()
        {
            Op = "Exists";
        }
        public static new LinstorNodeConnectionSpecSelectorMatchLabelsArgs Empty => new LinstorNodeConnectionSpecSelectorMatchLabelsArgs();
    }
}