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
    /// StripPrefix holds the strip prefix middleware configuration. This middleware removes the specified prefixes from the URL path. More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/stripprefix/
    /// </summary>
    [OutputType]
    public sealed class MiddlewareSpecStripPrefix
    {
        /// <summary>
        /// ForceSlash ensures that the resulting stripped path is not the empty string, by replacing it with / when necessary. Default: true.
        /// </summary>
        public readonly bool ForceSlash;
        /// <summary>
        /// Prefixes defines the prefixes to strip from the request URL.
        /// </summary>
        public readonly ImmutableArray<string> Prefixes;

        [OutputConstructor]
        private MiddlewareSpecStripPrefix(
            bool forceSlash,

            ImmutableArray<string> prefixes)
        {
            ForceSlash = forceSlash;
            Prefixes = prefixes;
        }
    }
}
