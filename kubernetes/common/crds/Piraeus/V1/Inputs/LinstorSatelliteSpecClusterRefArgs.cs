// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.Piraeus.V1
{

    /// <summary>
    /// ClusterRef references the LinstorCluster used to create this LinstorSatellite.
    /// </summary>
    public class LinstorSatelliteSpecClusterRefArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// ClientSecretName references the secret used by the operator to validate the https endpoint.
        /// </summary>
        [Input("clientSecretName")]
        public Input<string>? ClientSecretName { get; set; }

        /// <summary>
        /// ExternalController references an external controller. When set, the Operator uses the external cluster to register satellites.
        /// </summary>
        [Input("externalController")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Piraeus.V1.LinstorSatelliteSpecClusterRefExternalControllerArgs>? ExternalController { get; set; }

        /// <summary>
        /// Name of the LinstorCluster resource controlling this satellite.
        /// </summary>
        [Input("name")]
        public Input<string>? Name { get; set; }

        public LinstorSatelliteSpecClusterRefArgs()
        {
        }
        public static new LinstorSatelliteSpecClusterRefArgs Empty => new LinstorSatelliteSpecClusterRefArgs();
    }
}
