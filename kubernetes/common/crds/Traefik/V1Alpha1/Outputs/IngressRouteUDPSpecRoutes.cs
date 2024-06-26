// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1
{

    /// <summary>
    /// RouteUDP holds the UDP route configuration.
    /// </summary>
    [OutputType]
    public sealed class IngressRouteUDPSpecRoutes
    {
        /// <summary>
        /// Services defines the list of UDP services.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.IngressRouteUDPSpecRoutesServices> Services;

        [OutputConstructor]
        private IngressRouteUDPSpecRoutes(ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.IngressRouteUDPSpecRoutesServices> services)
        {
            Services = services;
        }
    }
}
