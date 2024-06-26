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
    public sealed class ScheduleSpecRestoreBackendAzure
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecRestoreBackendAzureAccountKeySecretRef AccountKeySecretRef;
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecRestoreBackendAzureAccountNameSecretRef AccountNameSecretRef;
        public readonly string Container;

        [OutputConstructor]
        private ScheduleSpecRestoreBackendAzure(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecRestoreBackendAzureAccountKeySecretRef accountKeySecretRef,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecRestoreBackendAzureAccountNameSecretRef accountNameSecretRef,

            string container)
        {
            AccountKeySecretRef = accountKeySecretRef;
            AccountNameSecretRef = accountNameSecretRef;
            Container = container;
        }
    }
}
