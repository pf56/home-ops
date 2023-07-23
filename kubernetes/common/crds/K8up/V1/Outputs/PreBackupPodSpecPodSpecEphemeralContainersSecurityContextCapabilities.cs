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
    /// The capabilities to add/drop when running containers. Defaults to the default set of capabilities granted by the container runtime. Note that this field cannot be set when spec.os.name is windows.
    /// </summary>
    [OutputType]
    public sealed class PreBackupPodSpecPodSpecEphemeralContainersSecurityContextCapabilities
    {
        /// <summary>
        /// Added capabilities
        /// </summary>
        public readonly ImmutableArray<string> Add;
        /// <summary>
        /// Removed capabilities
        /// </summary>
        public readonly ImmutableArray<string> Drop;

        [OutputConstructor]
        private PreBackupPodSpecPodSpecEphemeralContainersSecurityContextCapabilities(
            ImmutableArray<string> add,

            ImmutableArray<string> drop)
        {
            Add = add;
            Drop = drop;
        }
    }
}
