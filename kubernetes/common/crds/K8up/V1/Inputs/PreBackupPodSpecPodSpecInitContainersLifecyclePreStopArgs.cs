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
    /// PreStop is called immediately before a container is terminated due to an API request or management event such as liveness/startup probe failure, preemption, resource contention, etc. The handler is not called if the container crashes or exits. The Pod's termination grace period countdown begins before the PreStop hook is executed. Regardless of the outcome of the handler, the container will eventually terminate within the Pod's termination grace period (unless delayed by finalizers). Other management of the container blocks until the hook completes or until the termination grace period is reached. More info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks
    /// </summary>
    public class PreBackupPodSpecPodSpecInitContainersLifecyclePreStopArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Exec specifies the action to take.
        /// </summary>
        [Input("exec")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PreBackupPodSpecPodSpecInitContainersLifecyclePreStopExecArgs>? Exec { get; set; }

        /// <summary>
        /// HTTPGet specifies the http request to perform.
        /// </summary>
        [Input("httpGet")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PreBackupPodSpecPodSpecInitContainersLifecyclePreStopHttpGetArgs>? HttpGet { get; set; }

        /// <summary>
        /// Deprecated. TCPSocket is NOT supported as a LifecycleHandler and kept for the backward compatibility. There are no validation of this field and lifecycle hooks will fail in runtime when tcp handler is specified.
        /// </summary>
        [Input("tcpSocket")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PreBackupPodSpecPodSpecInitContainersLifecyclePreStopTcpSocketArgs>? TcpSocket { get; set; }

        public PreBackupPodSpecPodSpecInitContainersLifecyclePreStopArgs()
        {
        }
        public static new PreBackupPodSpecPodSpecInitContainersLifecyclePreStopArgs Empty => new PreBackupPodSpecPodSpecInitContainersLifecyclePreStopArgs();
    }
}
