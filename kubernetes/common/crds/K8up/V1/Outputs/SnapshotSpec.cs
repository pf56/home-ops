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
    /// SnapshotSpec contains all information needed about a restic snapshot so it can be restored.
    /// </summary>
    [OutputType]
    public sealed class SnapshotSpec
    {
        public readonly string Date;
        public readonly string Id;
        public readonly ImmutableArray<string> Paths;
        public readonly string Repository;

        [OutputConstructor]
        private SnapshotSpec(
            string date,

            string id,

            ImmutableArray<string> paths,

            string repository)
        {
            Date = date;
            Id = id;
            Paths = paths;
            Repository = repository;
        }
    }
}
