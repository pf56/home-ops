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
    /// Sticky defines whether sticky sessions are enabled. More info: https://doc.traefik.io/traefik/v2.10/routing/providers/kubernetes-crd/#stickiness-and-load-balancing
    /// </summary>
    [OutputType]
    public sealed class TraefikServiceSpecWeightedSticky
    {
        /// <summary>
        /// Cookie defines the sticky cookie configuration.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TraefikServiceSpecWeightedStickyCookie Cookie;

        [OutputConstructor]
        private TraefikServiceSpecWeightedSticky(Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TraefikServiceSpecWeightedStickyCookie cookie)
        {
            Cookie = cookie;
        }
    }
}
