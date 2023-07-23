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
    /// configMap represents a configMap that should populate this volume
    /// </summary>
    [OutputType]
    public sealed class PreBackupPodSpecPodSpecVolumesConfigMap
    {
        /// <summary>
        /// defaultMode is optional: mode bits used to set permissions on created files by default. Must be an octal value between 0000 and 0777 or a decimal value between 0 and 511. YAML accepts both octal and decimal values, JSON requires decimal values for mode bits. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
        /// </summary>
        public readonly int DefaultMode;
        /// <summary>
        /// items if unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecVolumesConfigMapItems> Items;
        /// <summary>
        /// Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?
        /// </summary>
        public readonly string Name;
        /// <summary>
        /// optional specify whether the ConfigMap or its keys must be defined
        /// </summary>
        public readonly bool Optional;

        [OutputConstructor]
        private PreBackupPodSpecPodSpecVolumesConfigMap(
            int defaultMode,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.K8up.V1.PreBackupPodSpecPodSpecVolumesConfigMapItems> items,

            string name,

            bool optional)
        {
            DefaultMode = defaultMode;
            Items = items;
            Name = name;
            Optional = optional;
        }
    }
}
