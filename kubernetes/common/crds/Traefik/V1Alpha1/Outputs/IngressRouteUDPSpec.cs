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
    /// IngressRouteUDPSpec defines the desired state of a IngressRouteUDP.
    /// </summary>
    [OutputType]
    public sealed class IngressRouteUDPSpec
    {
        /// <summary>
        /// EntryPoints defines the list of entry point names to bind to. Entry points have to be configured in the static configuration. More info: https://doc.traefik.io/traefik/v2.10/routing/entrypoints/ Default: all.
        /// </summary>
        public readonly ImmutableArray<string> EntryPoints;
        /// <summary>
        /// Routes defines the list of routes.
        /// </summary>
        public readonly ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.IngressRouteUDPSpecRoutes> Routes;

        [OutputConstructor]
        private IngressRouteUDPSpec(
            ImmutableArray<string> entryPoints,

            ImmutableArray<Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.IngressRouteUDPSpecRoutes> routes)
        {
            EntryPoints = entryPoints;
            Routes = routes;
        }
    }
}
