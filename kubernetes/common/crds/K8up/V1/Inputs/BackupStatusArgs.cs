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
    /// Status defines the observed state of a generic K8up job. It is used for the operator to determine what to do.
    /// </summary>
    public class BackupStatusArgs : global::Pulumi.ResourceArgs
    {
        [Input("conditions")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.BackupStatusConditionsArgs>? _conditions;

        /// <summary>
        /// Conditions provide a standard mechanism for higher-level status reporting from a controller. They are an extension mechanism which allows tools and other controllers to collect summary information about resources without needing to understand resource-specific status details.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.BackupStatusConditionsArgs> Conditions
        {
            get => _conditions ?? (_conditions = new InputList<Pulumi.Kubernetes.Types.Inputs.K8up.V1.BackupStatusConditionsArgs>());
            set => _conditions = value;
        }

        [Input("exclusive")]
        public Input<bool>? Exclusive { get; set; }

        [Input("finished")]
        public Input<bool>? Finished { get; set; }

        [Input("started")]
        public Input<bool>? Started { get; set; }

        public BackupStatusArgs()
        {
        }
        public static new BackupStatusArgs Empty => new BackupStatusArgs();
    }
}
