// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    public class PruneSpecBackendB2Args : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        [Input("accountIDSecretRef")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendB2AccountIDSecretRefArgs>? AccountIDSecretRef { get; set; }

        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        [Input("accountKeySecretRef")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecBackendB2AccountKeySecretRefArgs>? AccountKeySecretRef { get; set; }

        [Input("bucket")]
        public Input<string>? Bucket { get; set; }

        [Input("path")]
        public Input<string>? Path { get; set; }

        public PruneSpecBackendB2Args()
        {
        }
        public static new PruneSpecBackendB2Args Empty => new PruneSpecBackendB2Args();
    }
}
