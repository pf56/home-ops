// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    public class ArchiveSpecBackendS3Args : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        [Input("accessKeyIDSecretRef")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ArchiveSpecBackendS3AccessKeyIDSecretRefArgs>? AccessKeyIDSecretRef { get; set; }

        [Input("bucket")]
        public Input<string>? Bucket { get; set; }

        [Input("endpoint")]
        public Input<string>? Endpoint { get; set; }

        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        [Input("secretAccessKeySecretRef")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ArchiveSpecBackendS3SecretAccessKeySecretRefArgs>? SecretAccessKeySecretRef { get; set; }

        public ArchiveSpecBackendS3Args()
        {
        }
        public static new ArchiveSpecBackendS3Args Empty => new ArchiveSpecBackendS3Args();
    }
}
