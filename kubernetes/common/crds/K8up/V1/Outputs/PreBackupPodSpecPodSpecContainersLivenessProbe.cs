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
    /// Periodic probe of container liveness. Container will be restarted if the probe fails. Cannot be updated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
    /// </summary>
    [OutputType]
    public sealed class PreBackupPodSpecPodSpecContainersLivenessProbe
    {
        /// <summary>
        /// Exec specifies the action to take.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecContainersLivenessProbeExec Exec;
        /// <summary>
        /// Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.
        /// </summary>
        public readonly int FailureThreshold;
        /// <summary>
        /// GRPC specifies an action involving a GRPC port. This is a beta field and requires enabling GRPCContainerProbe feature gate.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecContainersLivenessProbeGrpc Grpc;
        /// <summary>
        /// HTTPGet specifies the http request to perform.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecContainersLivenessProbeHttpGet HttpGet;
        /// <summary>
        /// Number of seconds after the container has started before liveness probes are initiated. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
        /// </summary>
        public readonly int InitialDelaySeconds;
        /// <summary>
        /// How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.
        /// </summary>
        public readonly int PeriodSeconds;
        /// <summary>
        /// Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. Minimum value is 1.
        /// </summary>
        public readonly int SuccessThreshold;
        /// <summary>
        /// TCPSocket specifies an action involving a TCP port.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecContainersLivenessProbeTcpSocket TcpSocket;
        /// <summary>
        /// Optional duration in seconds the pod needs to terminate gracefully upon probe failure. The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process. If this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this value overrides the value provided by the pod spec. Value must be non-negative integer. The value zero indicates stop immediately via the kill signal (no opportunity to shut down). This is a beta field and requires enabling ProbeTerminationGracePeriod feature gate. Minimum value is 1. spec.terminationGracePeriodSeconds is used if unset.
        /// </summary>
        public readonly int TerminationGracePeriodSeconds;
        /// <summary>
        /// Number of seconds after which the probe times out. Defaults to 1 second. Minimum value is 1. More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes
        /// </summary>
        public readonly int TimeoutSeconds;

        [OutputConstructor]
        private PreBackupPodSpecPodSpecContainersLivenessProbe(
            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecContainersLivenessProbeExec exec,

            int failureThreshold,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecContainersLivenessProbeGrpc grpc,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecContainersLivenessProbeHttpGet httpGet,

            int initialDelaySeconds,

            int periodSeconds,

            int successThreshold,

            Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecContainersLivenessProbeTcpSocket tcpSocket,

            int terminationGracePeriodSeconds,

            int timeoutSeconds)
        {
            Exec = exec;
            FailureThreshold = failureThreshold;
            Grpc = grpc;
            HttpGet = httpGet;
            InitialDelaySeconds = initialDelaySeconds;
            PeriodSeconds = periodSeconds;
            SuccessThreshold = successThreshold;
            TcpSocket = tcpSocket;
            TerminationGracePeriodSeconds = terminationGracePeriodSeconds;
            TimeoutSeconds = timeoutSeconds;
        }
    }
}
