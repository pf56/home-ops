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
    /// BasicAuth holds the basic auth middleware configuration. This middleware restricts access to your services to known users. More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/basicauth/
    /// </summary>
    public class MiddlewareSpecBasicAuthArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// HeaderField defines a header field to store the authenticated user. More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/basicauth/#headerfield
        /// </summary>
        [Input("headerField")]
        public Input<string>? HeaderField { get; set; }

        /// <summary>
        /// Realm allows the protected resources on a server to be partitioned into a set of protection spaces, each with its own authentication scheme. Default: traefik.
        /// </summary>
        [Input("realm")]
        public Input<string>? Realm { get; set; }

        /// <summary>
        /// RemoveHeader sets the removeHeader option to true to remove the authorization header before forwarding the request to your service. Default: false.
        /// </summary>
        [Input("removeHeader")]
        public Input<bool>? RemoveHeader { get; set; }

        /// <summary>
        /// Secret is the name of the referenced Kubernetes Secret containing user credentials.
        /// </summary>
        [Input("secret")]
        public Input<string>? Secret { get; set; }

        public MiddlewareSpecBasicAuthArgs()
        {
        }
        public static new MiddlewareSpecBasicAuthArgs Empty => new MiddlewareSpecBasicAuthArgs();
    }
}
