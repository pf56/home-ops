// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    public class ScheduleSpecBackupBackendGcsArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        [Input("accessTokenSecretRef")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleSpecBackupBackendGcsAccessTokenSecretRefArgs>? AccessTokenSecretRef { get; set; }

        [Input("bucket")]
        public Input<string>? Bucket { get; set; }

        /// <summary>
        /// SecretKeySelector selects a key of a Secret.
        /// </summary>
        [Input("projectIDSecretRef")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ScheduleSpecBackupBackendGcsProjectIDSecretRefArgs>? ProjectIDSecretRef { get; set; }

        public ScheduleSpecBackupBackendGcsArgs()
        {
        }
        public static new ScheduleSpecBackupBackendGcsArgs Empty => new ScheduleSpecBackupBackendGcsArgs();
    }
}
