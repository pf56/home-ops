// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.Acme.V1
{

    /// <summary>
    /// PodSpec defines overrides for the HTTP01 challenge solver pod. Check ACMEChallengeSolverHTTP01IngressPodSpec to find out currently supported fields. All other fields will be ignored.
    /// </summary>
    [OutputType]
    public sealed class ChallengeSpecSolverHttp01IngressPodTemplateSpec
    {
        /// <summary>
        /// If specified, the pod's scheduling constraints
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Acme.V1.ChallengeSpecSolverHttp01IngressPodTemplateSpecAffinity Affinity;
        /// <summary>
        /// If specified, the pod's imagePullSecrets
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Acme.V1.ChallengeSpecSolverHttp01IngressPodTemplateSpecImagePullSecrets> ImagePullSecrets;
        /// <summary>
        /// NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. More info: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
        /// </summary>
        public readonly ImmutableDictionary<string, string> NodeSelector;
        /// <summary>
        /// If specified, the pod's priorityClassName.
        /// </summary>
        public readonly string PriorityClassName;
        /// <summary>
        /// If specified, the pod's service account
        /// </summary>
        public readonly string ServiceAccountName;
        /// <summary>
        /// If specified, the pod's tolerations.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Acme.V1.ChallengeSpecSolverHttp01IngressPodTemplateSpecTolerations> Tolerations;

        [OutputConstructor]
        private ChallengeSpecSolverHttp01IngressPodTemplateSpec(
            Pulumi.Kubernetes.Types.Outputs.Acme.V1.ChallengeSpecSolverHttp01IngressPodTemplateSpecAffinity affinity,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Acme.V1.ChallengeSpecSolverHttp01IngressPodTemplateSpecImagePullSecrets> imagePullSecrets,

            ImmutableDictionary<string, string> nodeSelector,

            string priorityClassName,

            string serviceAccountName,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Acme.V1.ChallengeSpecSolverHttp01IngressPodTemplateSpecTolerations> tolerations)
        {
            Affinity = affinity;
            ImagePullSecrets = imagePullSecrets;
            NodeSelector = nodeSelector;
            PriorityClassName = priorityClassName;
            ServiceAccountName = serviceAccountName;
            Tolerations = tolerations;
        }
    }
}
