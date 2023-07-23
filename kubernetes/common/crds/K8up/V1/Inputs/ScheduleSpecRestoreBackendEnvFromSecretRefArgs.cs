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
    /// The Secret to select from
    /// </summary>
    public class ScheduleSpecRestoreBackendEnvFromSecretRefArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?
        /// </summary>
        [Input("name")]
        public Input<string>? Name { get; set; }

        /// <summary>
        /// Specify whether the Secret must be defined
        /// </summary>
        [Input("optional")]
        public Input<bool>? Optional { get; set; }

        public ScheduleSpecRestoreBackendEnvFromSecretRefArgs()
        {
        }
        public static new ScheduleSpecRestoreBackendEnvFromSecretRefArgs Empty => new ScheduleSpecRestoreBackendEnvFromSecretRefArgs();
    }
}
