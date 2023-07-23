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
    /// ContainerPort represents a network port in a single container.
    /// </summary>
    [OutputType]
    public sealed class PreBackupPodSpecPodSpecInitContainersPorts
    {
        /// <summary>
        /// Number of port to expose on the pod's IP address. This must be a valid port number, 0 &lt; x &lt; 65536.
        /// </summary>
        public readonly int ContainerPort;
        /// <summary>
        /// What host IP to bind the external port to.
        /// </summary>
        public readonly string HostIP;
        /// <summary>
        /// Number of port to expose on the host. If specified, this must be a valid port number, 0 &lt; x &lt; 65536. If HostNetwork is specified, this must match ContainerPort. Most containers do not need this.
        /// </summary>
        public readonly int HostPort;
        /// <summary>
        /// If specified, this must be an IANA_SVC_NAME and unique within the pod. Each named port in a pod must have a unique name. Name for the port that can be referred to by services.
        /// </summary>
        public readonly string Name;
        /// <summary>
        /// Protocol for port. Must be UDP, TCP, or SCTP. Defaults to "TCP".
        /// </summary>
        public readonly string Protocol;

        [OutputConstructor]
        private PreBackupPodSpecPodSpecInitContainersPorts(
            int containerPort,

            string hostIP,

            int hostPort,

            string name,

            string protocol)
        {
            ContainerPort = containerPort;
            HostIP = hostIP;
            HostPort = hostPort;
            Name = name;
            Protocol = protocol;
        }
    }
}
