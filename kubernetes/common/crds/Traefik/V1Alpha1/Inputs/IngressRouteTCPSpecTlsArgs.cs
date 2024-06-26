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
    /// TLS defines the TLS configuration on a layer 4 / TCP Route. More info: https://doc.traefik.io/traefik/v2.10/routing/routers/#tls_1
    /// </summary>
    public class IngressRouteTCPSpecTlsArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// CertResolver defines the name of the certificate resolver to use. Cert resolvers have to be configured in the static configuration. More info: https://doc.traefik.io/traefik/v2.10/https/acme/#certificate-resolvers
        /// </summary>
        [Input("certResolver")]
        public Input<string>? CertResolver { get; set; }

        [Input("domains")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteTCPSpecTlsDomainsArgs>? _domains;

        /// <summary>
        /// Domains defines the list of domains that will be used to issue certificates. More info: https://doc.traefik.io/traefik/v2.10/routing/routers/#domains
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteTCPSpecTlsDomainsArgs> Domains
        {
            get => _domains ?? (_domains = new InputList<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteTCPSpecTlsDomainsArgs>());
            set => _domains = value;
        }

        /// <summary>
        /// Options defines the reference to a TLSOption, that specifies the parameters of the TLS connection. If not defined, the `default` TLSOption is used. More info: https://doc.traefik.io/traefik/v2.10/https/tls/#tls-options
        /// </summary>
        [Input("options")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteTCPSpecTlsOptionsArgs>? Options { get; set; }

        /// <summary>
        /// Passthrough defines whether a TLS router will terminate the TLS connection.
        /// </summary>
        [Input("passthrough")]
        public Input<bool>? Passthrough { get; set; }

        /// <summary>
        /// SecretName is the name of the referenced Kubernetes Secret to specify the certificate details.
        /// </summary>
        [Input("secretName")]
        public Input<string>? SecretName { get; set; }

        /// <summary>
        /// Store defines the reference to the TLSStore, that will be used to store certificates. Please note that only `default` TLSStore can be used.
        /// </summary>
        [Input("store")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.IngressRouteTCPSpecTlsStoreArgs>? Store { get; set; }

        public IngressRouteTCPSpecTlsArgs()
        {
        }
        public static new IngressRouteTCPSpecTlsArgs Empty => new IngressRouteTCPSpecTlsArgs();
    }
}
