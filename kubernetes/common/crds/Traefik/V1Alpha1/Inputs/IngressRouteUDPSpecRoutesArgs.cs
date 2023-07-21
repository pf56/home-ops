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
    /// RouteUDP holds the UDP route configuration.
    /// </summary>
    public class IngressRouteUDPSpecRoutesArgs : global::Pulumi.ResourceArgs
    {
        [Input("services")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteUDPSpecRoutesServicesArgs>? _services;

        /// <summary>
        /// Services defines the list of UDP services.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteUDPSpecRoutesServicesArgs> Services
        {
            get => _services ?? (_services = new InputList<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteUDPSpecRoutesServicesArgs>());
            set => _services = value;
        }

        public IngressRouteUDPSpecRoutesArgs()
        {
        }
        public static new IngressRouteUDPSpecRoutesArgs Empty => new IngressRouteUDPSpecRoutesArgs();
    }
}
