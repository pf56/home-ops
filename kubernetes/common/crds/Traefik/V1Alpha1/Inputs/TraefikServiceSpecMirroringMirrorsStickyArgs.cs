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
    /// Sticky defines the sticky sessions configuration. More info: https://doc.traefik.io/traefik/v2.10/routing/services/#sticky-sessions
    /// </summary>
    public class TraefikServiceSpecMirroringMirrorsStickyArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Cookie defines the sticky cookie configuration.
        /// </summary>
        [Input("cookie")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Traefik.V1Alpha1.TraefikServiceSpecMirroringMirrorsStickyCookieArgs>? Cookie { get; set; }

        public TraefikServiceSpecMirroringMirrorsStickyArgs()
        {
        }
        public static new TraefikServiceSpecMirroringMirrorsStickyArgs Empty => new TraefikServiceSpecMirroringMirrorsStickyArgs();
    }
}
