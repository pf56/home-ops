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
    /// PodSecurityContext describes the security context with which this action shall be executed.
    /// </summary>
    public class PruneSpecPodSecurityContextArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// A special supplemental group that applies to all containers in a pod. Some volume types allow the Kubelet to change the ownership of that volume to be owned by the pod: 
        ///  1. The owning GID will be the FSGroup 2. The setgid bit is set (new files created in the volume will be owned by FSGroup) 3. The permission bits are OR'd with rw-rw---- 
        ///  If unset, the Kubelet will not modify the ownership and permissions of any volume. Note that this field cannot be set when spec.os.name is windows.
        /// </summary>
        [Input("fsGroup")]
        public Input<int>? FsGroup { get; set; }

        /// <summary>
        /// fsGroupChangePolicy defines behavior of changing ownership and permission of the volume before being exposed inside Pod. This field will only apply to volume types which support fsGroup based ownership(and permissions). It will have no effect on ephemeral volume types such as: secret, configmaps and emptydir. Valid values are "OnRootMismatch" and "Always". If not specified, "Always" is used. Note that this field cannot be set when spec.os.name is windows.
        /// </summary>
        [Input("fsGroupChangePolicy")]
        public Input<string>? FsGroupChangePolicy { get; set; }

        /// <summary>
        /// The GID to run the entrypoint of the container process. Uses runtime default if unset. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container. Note that this field cannot be set when spec.os.name is windows.
        /// </summary>
        [Input("runAsGroup")]
        public Input<int>? RunAsGroup { get; set; }

        /// <summary>
        /// Indicates that the container must run as a non-root user. If true, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root) and fail to start the container if it does. If unset or false, no such validation will be performed. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.
        /// </summary>
        [Input("runAsNonRoot")]
        public Input<bool>? RunAsNonRoot { get; set; }

        /// <summary>
        /// The UID to run the entrypoint of the container process. Defaults to user specified in image metadata if unspecified. May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container. Note that this field cannot be set when spec.os.name is windows.
        /// </summary>
        [Input("runAsUser")]
        public Input<int>? RunAsUser { get; set; }

        /// <summary>
        /// The SELinux context to be applied to all containers. If unspecified, the container runtime will allocate a random SELinux context for each container.  May also be set in SecurityContext.  If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence for that container. Note that this field cannot be set when spec.os.name is windows.
        /// </summary>
        [Input("seLinuxOptions")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecPodSecurityContextSeLinuxOptionsArgs>? SeLinuxOptions { get; set; }

        /// <summary>
        /// The seccomp options to use by the containers in this pod. Note that this field cannot be set when spec.os.name is windows.
        /// </summary>
        [Input("seccompProfile")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecPodSecurityContextSeccompProfileArgs>? SeccompProfile { get; set; }

        [Input("supplementalGroups")]
        private InputList<int>? _supplementalGroups;

        /// <summary>
        /// A list of groups applied to the first process run in each container, in addition to the container's primary GID.  If unspecified, no groups will be added to any container. Note that this field cannot be set when spec.os.name is windows.
        /// </summary>
        public InputList<int> SupplementalGroups
        {
            get => _supplementalGroups ?? (_supplementalGroups = new InputList<int>());
            set => _supplementalGroups = value;
        }

        [Input("sysctls")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecPodSecurityContextSysctlsArgs>? _sysctls;

        /// <summary>
        /// Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported sysctls (by the container runtime) might fail to launch. Note that this field cannot be set when spec.os.name is windows.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecPodSecurityContextSysctlsArgs> Sysctls
        {
            get => _sysctls ?? (_sysctls = new InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecPodSecurityContextSysctlsArgs>());
            set => _sysctls = value;
        }

        /// <summary>
        /// The Windows specific settings applied to all containers. If unspecified, the options within a container's SecurityContext will be used. If set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence. Note that this field cannot be set when spec.os.name is linux.
        /// </summary>
        [Input("windowsOptions")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.PruneSpecPodSecurityContextWindowsOptionsArgs>? WindowsOptions { get; set; }

        public PruneSpecPodSecurityContextArgs()
        {
        }
        public static new PruneSpecPodSecurityContextArgs Empty => new PruneSpecPodSecurityContextArgs();
    }
}
