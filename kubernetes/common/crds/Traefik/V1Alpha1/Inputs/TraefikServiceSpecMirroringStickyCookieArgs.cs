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
    /// Cookie defines the sticky cookie configuration.
    /// </summary>
    public class TraefikServiceSpecMirroringStickyCookieArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// HTTPOnly defines whether the cookie can be accessed by client-side APIs, such as JavaScript.
        /// </summary>
        [Input("httpOnly")]
        public Input<bool>? HttpOnly { get; set; }

        /// <summary>
        /// Name defines the Cookie name.
        /// </summary>
        [Input("name")]
        public Input<string>? Name { get; set; }

        /// <summary>
        /// SameSite defines the same site policy. More info: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite
        /// </summary>
        [Input("sameSite")]
        public Input<string>? SameSite { get; set; }

        /// <summary>
        /// Secure defines whether the cookie can only be transmitted over an encrypted connection (i.e. HTTPS).
        /// </summary>
        [Input("secure")]
        public Input<bool>? Secure { get; set; }

        public TraefikServiceSpecMirroringStickyCookieArgs()
        {
        }
        public static new TraefikServiceSpecMirroringStickyCookieArgs Empty => new TraefikServiceSpecMirroringStickyCookieArgs();
    }
}
