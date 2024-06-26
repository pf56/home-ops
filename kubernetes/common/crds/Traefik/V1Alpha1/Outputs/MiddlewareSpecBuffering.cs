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
    /// Buffering holds the buffering middleware configuration. This middleware retries or limits the size of requests that can be forwarded to backends. More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/buffering/#maxrequestbodybytes
    /// </summary>
    [OutputType]
    public sealed class MiddlewareSpecBuffering
    {
        /// <summary>
        /// MaxRequestBodyBytes defines the maximum allowed body size for the request (in bytes). If the request exceeds the allowed size, it is not forwarded to the service, and the client gets a 413 (Request Entity Too Large) response. Default: 0 (no maximum).
        /// </summary>
        public readonly int MaxRequestBodyBytes;
        /// <summary>
        /// MaxResponseBodyBytes defines the maximum allowed response size from the service (in bytes). If the response exceeds the allowed size, it is not forwarded to the client. The client gets a 500 (Internal Server Error) response instead. Default: 0 (no maximum).
        /// </summary>
        public readonly int MaxResponseBodyBytes;
        /// <summary>
        /// MemRequestBodyBytes defines the threshold (in bytes) from which the request will be buffered on disk instead of in memory. Default: 1048576 (1Mi).
        /// </summary>
        public readonly int MemRequestBodyBytes;
        /// <summary>
        /// MemResponseBodyBytes defines the threshold (in bytes) from which the response will be buffered on disk instead of in memory. Default: 1048576 (1Mi).
        /// </summary>
        public readonly int MemResponseBodyBytes;
        /// <summary>
        /// RetryExpression defines the retry conditions. It is a logical combination of functions with operators AND (&amp;&amp;) and OR (||). More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/buffering/#retryexpression
        /// </summary>
        public readonly string RetryExpression;

        [OutputConstructor]
        private MiddlewareSpecBuffering(
            int maxRequestBodyBytes,

            int maxResponseBodyBytes,

            int memRequestBodyBytes,

            int memResponseBodyBytes,

            string retryExpression)
        {
            MaxRequestBodyBytes = maxRequestBodyBytes;
            MaxResponseBodyBytes = maxResponseBodyBytes;
            MemRequestBodyBytes = memRequestBodyBytes;
            MemResponseBodyBytes = memResponseBodyBytes;
            RetryExpression = retryExpression;
        }
    }
}
