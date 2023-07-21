// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1
{

    /// <summary>
    /// TraefikServiceSpec defines the desired state of a TraefikService.
    /// </summary>
    public class TraefikServiceSpecArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Mirroring defines the Mirroring service configuration.
        /// </summary>
        [Input("mirroring")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.TraefikServiceSpecMirroringArgs>? Mirroring { get; set; }

        /// <summary>
        /// Weighted defines the Weighted Round Robin configuration.
        /// </summary>
        [Input("weighted")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.TraefikServiceSpecWeightedArgs>? Weighted { get; set; }

        public TraefikServiceSpecArgs()
        {
        }
        public static new TraefikServiceSpecArgs Empty => new TraefikServiceSpecArgs();
    }
}
