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
    /// If specified, the pod's scheduling constraints
    /// </summary>
    [OutputType]
    public sealed class PreBackupPodSpecPodSpecAffinity
    {
        /// <summary>
        /// Describes node affinity scheduling rules for the pod.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecAffinityNodeAffinity NodeAffinity;
        /// <summary>
        /// Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s)).
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecAffinityPodAffinity PodAffinity;
        /// <summary>
        /// Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s)).
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecAffinityPodAntiAffinity PodAntiAffinity;

        [OutputConstructor]
        private PreBackupPodSpecPodSpecAffinity(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecAffinityNodeAffinity nodeAffinity,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecAffinityPodAffinity podAffinity,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecAffinityPodAntiAffinity podAntiAffinity)
        {
            NodeAffinity = nodeAffinity;
            PodAffinity = podAffinity;
            PodAntiAffinity = podAntiAffinity;
        }
    }
}