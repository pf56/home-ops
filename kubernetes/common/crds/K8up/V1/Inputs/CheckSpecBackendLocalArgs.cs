// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    public class CheckSpecBackendLocalArgs : global::Pulumi.ResourceArgs
    {
        [Input("mountPath")]
        public Input<string>? MountPath { get; set; }

        public CheckSpecBackendLocalArgs()
        {
        }
        public static new CheckSpecBackendLocalArgs Empty => new CheckSpecBackendLocalArgs();
    }
}
