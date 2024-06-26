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
    /// IPStrategy holds the IP strategy configuration used by Traefik to determine the client IP. More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/ipwhitelist/#ipstrategy
    /// </summary>
    [OutputType]
    public sealed class MiddlewareSpecIpWhiteListIpStrategy
    {
        /// <summary>
        /// Depth tells Traefik to use the X-Forwarded-For header and take the IP located at the depth position (starting from the right).
        /// </summary>
        public readonly int Depth;
        /// <summary>
        /// ExcludedIPs configures Traefik to scan the X-Forwarded-For header and select the first IP not in the list.
        /// </summary>
        public readonly ImmutableArray<string> ExcludedIPs;

        [OutputConstructor]
        private MiddlewareSpecIpWhiteListIpStrategy(
            int depth,

            ImmutableArray<string> excludedIPs)
        {
            Depth = depth;
            ExcludedIPs = excludedIPs;
        }
    }
}
