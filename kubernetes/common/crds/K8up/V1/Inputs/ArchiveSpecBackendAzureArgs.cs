// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    public class ArchiveSpecBackendAzureArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        [Input("accountKeySecretRef")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ArchiveSpecBackendAzureAccountKeySecretRefArgs>? AccountKeySecretRef { get; set; }

        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        [Input("accountNameSecretRef")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ArchiveSpecBackendAzureAccountNameSecretRefArgs>? AccountNameSecretRef { get; set; }

        [Input("container")]
        public Input<string>? Container { get; set; }

        public ArchiveSpecBackendAzureArgs()
        {
        }
        public static new ArchiveSpecBackendAzureArgs Empty => new ArchiveSpecBackendAzureArgs();
    }
}