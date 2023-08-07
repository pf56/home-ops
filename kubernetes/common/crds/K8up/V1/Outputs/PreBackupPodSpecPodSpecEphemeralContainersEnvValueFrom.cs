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
    /// Source for the environment variable's value. Cannot be used if value is not empty.
    /// </summary>
    [OutputType]
    public sealed class PreBackupPodSpecPodSpecEphemeralContainersEnvValueFrom
    {
        /// <summary>
        /// Selects a key of a ConfigMap.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromConfigMapKeyRef ConfigMapKeyRef;
        /// <summary>
        /// Selects a field of the pod: supports metadata.name, metadata.namespace, `metadata.labels['&lt;KEY&gt;']`, `metadata.annotations['&lt;KEY&gt;']`, spec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromFieldRef FieldRef;
        /// <summary>
        /// Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromResourceFieldRef ResourceFieldRef;
        /// <summary>
        /// Selects a key of a secret in the pod's namespace
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromSecretKeyRef SecretKeyRef;

        [OutputConstructor]
        private PreBackupPodSpecPodSpecEphemeralContainersEnvValueFrom(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromConfigMapKeyRef configMapKeyRef,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromFieldRef fieldRef,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromResourceFieldRef resourceFieldRef,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromSecretKeyRef secretKeyRef)
        {
            ConfigMapKeyRef = configMapKeyRef;
            FieldRef = fieldRef;
            ResourceFieldRef = resourceFieldRef;
            SecretKeyRef = secretKeyRef;
        }
    }
}