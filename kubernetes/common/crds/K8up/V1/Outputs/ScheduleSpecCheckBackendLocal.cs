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
    public sealed class ScheduleSpecCheckBackendLocal
    {
        public readonly string MountPath;

        [OutputConstructor]
        private ScheduleSpecCheckBackendLocal(string mountPath)
        {
            MountPath = mountPath;
        }
    }
}