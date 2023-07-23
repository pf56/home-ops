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
    /// Sysctl defines a kernel parameter to be set
    /// </summary>
    [OutputType]
    public sealed class ScheduleSpecPodSecurityContextSysctls
    {
        /// <summary>
        /// Name of a property to set
        /// </summary>
        public readonly string Name;
        /// <summary>
        /// Value of a property to set
        /// </summary>
        public readonly string Value;

        [OutputConstructor]
        private ScheduleSpecPodSecurityContextSysctls(
            string name,

            string value)
        {
            Name = name;
            Value = value;
        }
    }
}
