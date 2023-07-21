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
    /// ResponseForwarding defines how Traefik forwards the response from the upstream Kubernetes Service to the client.
    /// </summary>
    [OutputType]
    public sealed class IngressRouteSpecRoutesServicesResponseForwarding
    {
        /// <summary>
        /// FlushInterval defines the interval, in milliseconds, in between flushes to the client while copying the response body. A negative value means to flush immediately after each write to the client. This configuration is ignored when ReverseProxy recognizes a response as a streaming response; for such responses, writes are flushed to the client immediately. Default: 100ms
        /// </summary>
        public readonly string FlushInterval;

        [OutputConstructor]
        private IngressRouteSpecRoutesServicesResponseForwarding(string flushInterval)
        {
            FlushInterval = flushInterval;
        }
    }
}
