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
    /// RestoreMethod contains how and where the restore should happen all the settings are mutual exclusive.
    /// </summary>
    public class ArchiveSpecRestoreMethodArgs : global::Pulumi.ResourceArgs
    {
        [Input("folder")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ArchiveSpecRestoreMethodFolderArgs>? Folder { get; set; }

        [Input("s3")]
        public Input<Pulumi.Kubernetes.Types.Inputs.K8up.V1.ArchiveSpecRestoreMethodS3Args>? S3 { get; set; }

        public ArchiveSpecRestoreMethodArgs()
        {
        }
        public static new ArchiveSpecRestoreMethodArgs Empty => new ArchiveSpecRestoreMethodArgs();
    }
}