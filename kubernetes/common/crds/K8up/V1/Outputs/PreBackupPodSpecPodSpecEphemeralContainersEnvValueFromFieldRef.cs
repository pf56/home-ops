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
    /// Selects a field of the pod: supports metadata.name, metadata.namespace, `metadata.labels['&lt;KEY&gt;']`, `metadata.annotations['&lt;KEY&gt;']`, spec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs.
    /// </summary>
    [OutputType]
    public sealed class PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromFieldRef
    {
        /// <summary>
        /// Version of the schema the FieldPath is written in terms of, defaults to "v1".
        /// </summary>
        public readonly string ApiVersion;
        /// <summary>
        /// Path of the field to select in the specified API version.
        /// </summary>
        public readonly string FieldPath;

        [OutputConstructor]
        private PreBackupPodSpecPodSpecEphemeralContainersEnvValueFromFieldRef(
            string apiVersion,

            string fieldPath)
        {
            ApiVersion = apiVersion;
            FieldPath = fieldPath;
        }
    }
}
