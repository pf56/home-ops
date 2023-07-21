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
    /// LocalObjectReference contains enough information to let you locate the referenced object inside the same namespace.
    /// </summary>
    [OutputType]
    public sealed class ChallengeSpecSolverHttp01IngressPodTemplateSpecImagePullSecrets
    {
        /// <summary>
        /// Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?
        /// </summary>
        public readonly string Name;

        [OutputConstructor]
        private ChallengeSpecSolverHttp01IngressPodTemplateSpecImagePullSecrets(string name)
        {
            Name = name;
        }
    }
}
