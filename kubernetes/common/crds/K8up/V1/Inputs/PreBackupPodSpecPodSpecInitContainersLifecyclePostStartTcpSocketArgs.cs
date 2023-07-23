// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    /// <summary>
    /// Deprecated. TCPSocket is NOT supported as a LifecycleHandler and kept for the backward compatibility. There are no validation of this field and lifecycle hooks will fail in runtime when tcp handler is specified.
    /// </summary>
    public class PreBackupPodSpecPodSpecInitContainersLifecyclePostStartTcpSocketArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Optional: Host name to connect to, defaults to the pod IP.
        /// </summary>
        [Input("host")]
        public Input<string>? Host { get; set; }

        /// <summary>
        /// Number or name of the port to access on the container. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME.
        /// </summary>
        [Input("port", required: true)]
        public InputUnion<int, string> Port { get; set; } = null!;

        public PreBackupPodSpecPodSpecInitContainersLifecyclePostStartTcpSocketArgs()
        {
        }
        public static new PreBackupPodSpecPodSpecInitContainersLifecyclePostStartTcpSocketArgs Empty => new PreBackupPodSpecPodSpecInitContainersLifecyclePostStartTcpSocketArgs();
    }
}
