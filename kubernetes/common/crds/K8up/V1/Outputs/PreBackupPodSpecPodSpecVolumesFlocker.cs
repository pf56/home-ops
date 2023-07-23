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
    /// flocker represents a Flocker volume attached to a kubelet's host machine. This depends on the Flocker control service being running
    /// </summary>
    [OutputType]
    public sealed class PreBackupPodSpecPodSpecVolumesFlocker
    {
        /// <summary>
        /// datasetName is Name of the dataset stored as metadata -&gt; name on the dataset for Flocker should be considered as deprecated
        /// </summary>
        public readonly string DatasetName;
        /// <summary>
        /// datasetUUID is the UUID of the dataset. This is unique identifier of a Flocker dataset
        /// </summary>
        public readonly string DatasetUUID;

        [OutputConstructor]
        private PreBackupPodSpecPodSpecVolumesFlocker(
            string datasetName,

            string datasetUUID)
        {
            DatasetName = datasetName;
            DatasetUUID = datasetUUID;
        }
    }
}
