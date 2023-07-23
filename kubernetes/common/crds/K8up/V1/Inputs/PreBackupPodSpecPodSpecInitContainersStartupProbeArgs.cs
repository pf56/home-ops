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
    /// StartupProbe indicates that the Pod has successfully initialized. If specified, no other probes are executed until this completes successfully. If this probe fails, the Pod will be restarted, just as if the livenessProbe failed. This can be used to provide different probe parameters at the beginning of a Pod's lifecycle, when it might take a long time to load data or warm a cache, than during steady-state operation. This cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
    /// </summary>
    public class PreBackupPodSpecPodSpecInitContainersStartupProbeArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Exec specifies the action to take.
        /// </summary>
        [Input("exec")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PreBackupPodSpecPodSpecInitContainersStartupProbeExecArgs>? Exec { get; set; }

        /// <summary>
        /// Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
        /// </summary>
        [Input("failureThreshold")]
        public Input<int>? FailureThreshold { get; set; }

        /// <summary>
        /// GRPC specifies an action involving a GRPC port. This is a beta field and requires enabling GRPCContainerProbe feature gate.
        /// </summary>
        [Input("grpc")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PreBackupPodSpecPodSpecInitContainersStartupProbeGrpcArgs>? Grpc { get; set; }

        /// <summary>
        /// HTTPGet specifies the http request to perform.
        /// </summary>
        [Input("httpGet")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PreBackupPodSpecPodSpecInitContainersStartupProbeHttpGetArgs>? HttpGet { get; set; }

        /// <summary>
        /// Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
        /// </summary>
        [Input("initialDelaySeconds")]
        public Input<int>? InitialDelaySeconds { get; set; }

        /// <summary>
        /// How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
        /// </summary>
        [Input("periodSeconds")]
        public Input<int>? PeriodSeconds { get; set; }

        /// <summary>
        /// Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
        /// </summary>
        [Input("successThreshold")]
        public Input<int>? SuccessThreshold { get; set; }

        /// <summary>
        /// TCPSocket specifies an action involving a TCP port.
        /// </summary>
        [Input("tcpSocket")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PreBackupPodSpecPodSpecInitContainersStartupProbeTcpSocketArgs>? TcpSocket { get; set; }

        /// <summary>
        /// Optional duration in seconds the pod needs to terminate gracefully upon probe failure. The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process. If this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this value overrides the value provided by the pod spec. Value must be non-negative integer. The value zero indicates stop immediately via the kill signal (no opportunity to shut down). This is a beta field and requires enabling ProbeTerminationGracePeriod feature gate. Minimum value is 1. spec.terminationGracePeriodSeconds is used if unset.
        /// </summary>
        [Input("terminationGracePeriodSeconds")]
        public Input<int>? TerminationGracePeriodSeconds { get; set; }

        /// <summary>
        /// Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
        /// </summary>
        [Input("timeoutSeconds")]
        public Input<int>? TimeoutSeconds { get; set; }

        public PreBackupPodSpecPodSpecInitContainersStartupProbeArgs()
        {
        }
        public static new PreBackupPodSpecPodSpecInitContainersStartupProbeArgs Empty => new PreBackupPodSpecPodSpecInitContainersStartupProbeArgs();
    }
}
