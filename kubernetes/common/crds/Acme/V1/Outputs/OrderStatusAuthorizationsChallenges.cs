// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Outputs.Acme.V1
{

    /// <summary>
    /// Challenge specifies a challenge offered by the ACME server for an Order. An appropriate Challenge resource can be created to perform the ACME challenge process.
    /// </summary>
    [OutputType]
    public sealed class OrderStatusAuthorizationsChallenges
    {
        /// <summary>
        /// Token is the token that must be presented for this challenge. This is used to compute the 'key' that must also be presented.
        /// </summary>
        public readonly string Token;
        /// <summary>
        /// Type is the type of challenge being offered, e.g. 'http-01', 'dns-01', 'tls-sni-01', etc. This is the raw value retrieved from the ACME server. Only 'http-01' and 'dns-01' are supported by cert-manager, other values will be ignored.
        /// </summary>
        public readonly string Type;
        /// <summary>
        /// URL is the URL of this challenge. It can be used to retrieve additional metadata about the Challenge from the ACME server.
        /// </summary>
        public readonly string Url;

        [OutputConstructor]
        private OrderStatusAuthorizationsChallenges(
            string token,

            string type,

            string url)
        {
            Token = token;
            Type = type;
            Url = url;
        }
    }
}
