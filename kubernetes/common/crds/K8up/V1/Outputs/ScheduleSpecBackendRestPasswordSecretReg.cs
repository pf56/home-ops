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
    /// SecretKeySelector selects a key of a Secret.
    /// </summary>
    [OutputType]
    public sealed class ScheduleSpecBackendRestPasswordSecretReg
    {
        /// <summary>
        /// The key of the secret to select from.  Must be a valid secret key.
        /// </summary>
        public readonly string Key;
        /// <summary>
        /// Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?
        /// </summary>
        public readonly string Name;
        /// <summary>
        /// Specify whether the Secret or its key must be defined
        /// </summary>
        public readonly bool Optional;

        [OutputConstructor]
        private ScheduleSpecBackendRestPasswordSecretReg(
            string key,

            string name,

            bool optional)
        {
            Key = key;
            Name = name;
            Optional = optional;
        }
    }
}
