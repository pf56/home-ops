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
    /// Domain holds a domain name with SANs.
    /// </summary>
    public class IngressRouteSpecTlsDomainsArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Main defines the main domain name.
        /// </summary>
        [Input("main")]
        public Input<string>? Main { get; set; }

        [Input("sans")]
        private InputList<string>? _sans;

        /// <summary>
        /// SANs defines the subject alternative domain names.
        /// </summary>
        public InputList<string> Sans
        {
            get => _sans ?? (_sans = new InputList<string>());
            set => _sans = value;
        }

        public IngressRouteSpecTlsDomainsArgs()
        {
        }
        public static new IngressRouteSpecTlsDomainsArgs Empty => new IngressRouteSpecTlsDomainsArgs();
    }
}
