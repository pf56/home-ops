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
    /// ForwardAuth holds the forward auth middleware configuration. This middleware delegates the request authentication to a Service. More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/forwardauth/
    /// </summary>
    [OutputType]
    public sealed class MiddlewareSpecForwardAuth
    {
        /// <summary>
        /// Address defines the authentication server address.
        /// </summary>
        public readonly string Address;
        /// <summary>
        /// AuthRequestHeaders defines the list of the headers to copy from the request to the authentication server. If not set or empty then all request headers are passed.
        /// </summary>
        public readonly ImmutableArray<string> AuthRequestHeaders;
        /// <summary>
        /// AuthResponseHeaders defines the list of headers to copy from the authentication server response and set on forwarded request, replacing any existing conflicting headers.
        /// </summary>
        public readonly ImmutableArray<string> AuthResponseHeaders;
        /// <summary>
        /// AuthResponseHeadersRegex defines the regex to match headers to copy from the authentication server response and set on forwarded request, after stripping all headers that match the regex. More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/forwardauth/#authresponseheadersregex
        /// </summary>
        public readonly string AuthResponseHeadersRegex;
        /// <summary>
        /// TLS defines the configuration used to secure the connection to the authentication server.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.MiddlewareSpecForwardAuthTls Tls;
        /// <summary>
        /// TrustForwardHeader defines whether to trust (ie: forward) all X-Forwarded-* headers.
        /// </summary>
        public readonly bool TrustForwardHeader;

        [OutputConstructor]
        private MiddlewareSpecForwardAuth(
            string address,

            ImmutableArray<string> authRequestHeaders,

            ImmutableArray<string> authResponseHeaders,

            string authResponseHeadersRegex,

            Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.MiddlewareSpecForwardAuthTls tls,

            bool trustForwardHeader)
        {
            Address = address;
            AuthRequestHeaders = authRequestHeaders;
            AuthResponseHeaders = authResponseHeaders;
            AuthResponseHeadersRegex = authResponseHeadersRegex;
            Tls = tls;
            TrustForwardHeader = trustForwardHeader;
        }
    }
}