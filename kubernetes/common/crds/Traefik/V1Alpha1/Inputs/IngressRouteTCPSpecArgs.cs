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
    /// IngressRouteTCPSpec defines the desired state of IngressRouteTCP.
    /// </summary>
    public class IngressRouteTCPSpecArgs : global::Pulumi.ResourceArgs
    {
        [Input("entryPoints")]
        private InputList<string>? _entryPoints;

        /// <summary>
        /// EntryPoints defines the list of entry point names to bind to. Entry points have to be configured in the static configuration. More info: https://doc.traefik.io/traefik/v2.10/routing/entrypoints/ Default: all.
        /// </summary>
        public InputList<string> EntryPoints
        {
            get => _entryPoints ?? (_entryPoints = new InputList<string>());
            set => _entryPoints = value;
        }

        [Input("routes", required: true)]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteTCPSpecRoutesArgs>? _routes;

        /// <summary>
        /// Routes defines the list of routes.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteTCPSpecRoutesArgs> Routes
        {
            get => _routes ?? (_routes = new InputList<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteTCPSpecRoutesArgs>());
            set => _routes = value;
        }

        /// <summary>
        /// TLS defines the TLS configuration on a layer 4 / TCP Route. More info: https://doc.traefik.io/traefik/v2.10/routing/routers/#tls_1
        /// </summary>
        [Input("tls")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteTCPSpecTlsArgs>? Tls { get; set; }

        public IngressRouteTCPSpecArgs()
        {
        }
        public static new IngressRouteTCPSpecArgs Empty => new IngressRouteTCPSpecArgs();
    }
}
