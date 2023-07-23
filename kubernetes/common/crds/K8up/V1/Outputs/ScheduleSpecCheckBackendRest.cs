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
    public sealed class ScheduleSpecCheckBackendRest
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendRestPasswordSecretReg PasswordSecretReg;
        public readonly string Url;
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendRestUserSecretRef UserSecretRef;

        [OutputConstructor]
        private ScheduleSpecCheckBackendRest(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendRestPasswordSecretReg passwordSecretReg,

            string url,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecCheckBackendRestUserSecretRef userSecretRef)
        {
            PasswordSecretReg = passwordSecretReg;
            Url = url;
            UserSecretRef = userSecretRef;
        }
    }
}
