// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.K8up.V1
{

    /// <summary>
    /// EnvFromSource represents the source of a set of ConfigMaps
    /// </summary>
    [OutputType]
    public sealed class ScheduleSpecBackendEnvFrom
    {
        /// <summary>
        /// The ConfigMap to select from
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecBackendEnvFromConfigMapRef ConfigMapRef;
        /// <summary>
        /// An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER.
        /// </summary>
        public readonly string Prefix;
        /// <summary>
        /// The Secret to select from
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecBackendEnvFromSecretRef SecretRef;

        [OutputConstructor]
        private ScheduleSpecBackendEnvFrom(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecBackendEnvFromConfigMapRef configMapRef,

            string prefix,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.ScheduleSpecBackendEnvFromSecretRef secretRef)
        {
            ConfigMapRef = configMapRef;
            Prefix = prefix;
            SecretRef = secretRef;
        }
    }
}
