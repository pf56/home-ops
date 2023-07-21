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
    /// RedirectScheme holds the redirect scheme middleware configuration. This middleware redirects requests from a scheme/port to another. More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/redirectscheme/
    /// </summary>
    public class MiddlewareSpecRedirectSchemeArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// Permanent defines whether the redirection is permanent (301).
        /// </summary>
        [Input("permanent")]
        public Input<bool>? Permanent { get; set; }

        /// <summary>
        /// Port defines the port of the new URL.
        /// </summary>
        [Input("port")]
        public Input<string>? Port { get; set; }

        /// <summary>
        /// Scheme defines the scheme of the new URL.
        /// </summary>
        [Input("scheme")]
        public Input<string>? Scheme { get; set; }

        public MiddlewareSpecRedirectSchemeArgs()
        {
        }
        public static new MiddlewareSpecRedirectSchemeArgs Empty => new MiddlewareSpecRedirectSchemeArgs();
    }
}
