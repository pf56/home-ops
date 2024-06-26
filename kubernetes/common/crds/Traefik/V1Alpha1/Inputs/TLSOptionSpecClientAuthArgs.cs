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
    /// ClientAuth defines the server's policy for TLS Client Authentication.
    /// </summary>
    public class TLSOptionSpecClientAuthArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// ClientAuthType defines the client authentication type to apply.
        /// </summary>
        [Input("clientAuthType")]
        public Input<string>? ClientAuthType { get; set; }

        [Input("secretNames")]
        private InputList<string>? _secretNames;

        /// <summary>
        /// SecretNames defines the names of the referenced Kubernetes Secret storing certificate details.
        /// </summary>
        public InputList<string> SecretNames
        {
            get => _secretNames ?? (_secretNames = new InputList<string>());
            set => _secretNames = value;
        }

        public TLSOptionSpecClientAuthArgs()
        {
        }
        public static new TLSOptionSpecClientAuthArgs Empty => new TLSOptionSpecClientAuthArgs();
    }
}
