// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.K8up.V1
{

    [OutputType]
    public sealed class RestoreSpecBackendS3
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.RestoreSpecBackendS3AccessKeyIDSecretRef AccessKeyIDSecretRef;
        public readonly string Bucket;
        public readonly string Endpoint;
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.RestoreSpecBackendS3SecretAccessKeySecretRef SecretAccessKeySecretRef;

        [OutputConstructor]
        private RestoreSpecBackendS3(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.RestoreSpecBackendS3AccessKeyIDSecretRef accessKeyIDSecretRef,

            string bucket,

            string endpoint,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.RestoreSpecBackendS3SecretAccessKeySecretRef secretAccessKeySecretRef)
        {
            AccessKeyIDSecretRef = accessKeyIDSecretRef;
            Bucket = bucket;
            Endpoint = endpoint;
            SecretAccessKeySecretRef = secretAccessKeySecretRef;
        }
    }
}
