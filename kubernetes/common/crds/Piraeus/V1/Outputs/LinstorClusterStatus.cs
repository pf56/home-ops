// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.Piraeus.V1
{

    /// <summary>
    /// LinstorClusterStatus defines the observed state of LinstorCluster
    /// </summary>
    [OutputType]
    public sealed class LinstorClusterStatus
    {
        /// <summary>
        /// Current LINSTOR Cluster state
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorClusterStatusConditions> Conditions;

        [OutputConstructor]
        private LinstorClusterStatus(ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Piraeus.V1.LinstorClusterStatusConditions> conditions)
        {
            Conditions = conditions;
        }
    }
}
