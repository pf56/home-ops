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
    /// Headers holds the headers middleware configuration. This middleware manages the requests and responses headers. More info: https://doc.traefik.io/traefik/v2.10/middlewares/http/headers/#customrequestheaders
    /// </summary>
    [OutputType]
    public sealed class MiddlewareSpecHeaders
    {
        /// <summary>
        /// AccessControlAllowCredentials defines whether the request can include user credentials.
        /// </summary>
        public readonly bool AccessControlAllowCredentials;
        /// <summary>
        /// AccessControlAllowHeaders defines the Access-Control-Request-Headers values sent in preflight response.
        /// </summary>
        public readonly ImmutableArray<string> AccessControlAllowHeaders;
        /// <summary>
        /// AccessControlAllowMethods defines the Access-Control-Request-Method values sent in preflight response.
        /// </summary>
        public readonly ImmutableArray<string> AccessControlAllowMethods;
        /// <summary>
        /// AccessControlAllowOriginList is a list of allowable origins. Can also be a wildcard origin "*".
        /// </summary>
        public readonly ImmutableArray<string> AccessControlAllowOriginList;
        /// <summary>
        /// AccessControlAllowOriginListRegex is a list of allowable origins written following the Regular Expression syntax (https://golang.org/pkg/regexp/).
        /// </summary>
        public readonly ImmutableArray<string> AccessControlAllowOriginListRegex;
        /// <summary>
        /// AccessControlExposeHeaders defines the Access-Control-Expose-Headers values sent in preflight response.
        /// </summary>
        public readonly ImmutableArray<string> AccessControlExposeHeaders;
        /// <summary>
        /// AccessControlMaxAge defines the time that a preflight request may be cached.
        /// </summary>
        public readonly int AccessControlMaxAge;
        /// <summary>
        /// AddVaryHeader defines whether the Vary header is automatically added/updated when the AccessControlAllowOriginList is set.
        /// </summary>
        public readonly bool AddVaryHeader;
        /// <summary>
        /// AllowedHosts defines the fully qualified list of allowed domain names.
        /// </summary>
        public readonly ImmutableArray<string> AllowedHosts;
        /// <summary>
        /// BrowserXSSFilter defines whether to add the X-XSS-Protection header with the value 1; mode=block.
        /// </summary>
        public readonly bool BrowserXssFilter;
        /// <summary>
        /// ContentSecurityPolicy defines the Content-Security-Policy header value.
        /// </summary>
        public readonly string ContentSecurityPolicy;
        /// <summary>
        /// ContentTypeNosniff defines whether to add the X-Content-Type-Options header with the nosniff value.
        /// </summary>
        public readonly bool ContentTypeNosniff;
        /// <summary>
        /// CustomBrowserXSSValue defines the X-XSS-Protection header value. This overrides the BrowserXssFilter option.
        /// </summary>
        public readonly string CustomBrowserXSSValue;
        /// <summary>
        /// CustomFrameOptionsValue defines the X-Frame-Options header value. This overrides the FrameDeny option.
        /// </summary>
        public readonly string CustomFrameOptionsValue;
        /// <summary>
        /// CustomRequestHeaders defines the header names and values to apply to the request.
        /// </summary>
        public readonly ImmutableDictionary<string, string> CustomRequestHeaders;
        /// <summary>
        /// CustomResponseHeaders defines the header names and values to apply to the response.
        /// </summary>
        public readonly ImmutableDictionary<string, string> CustomResponseHeaders;
        /// <summary>
        /// Deprecated: use PermissionsPolicy instead.
        /// </summary>
        public readonly string FeaturePolicy;
        /// <summary>
        /// ForceSTSHeader defines whether to add the STS header even when the connection is HTTP.
        /// </summary>
        public readonly bool ForceSTSHeader;
        /// <summary>
        /// FrameDeny defines whether to add the X-Frame-Options header with the DENY value.
        /// </summary>
        public readonly bool FrameDeny;
        /// <summary>
        /// HostsProxyHeaders defines the header keys that may hold a proxied hostname value for the request.
        /// </summary>
        public readonly ImmutableArray<string> HostsProxyHeaders;
        /// <summary>
        /// IsDevelopment defines whether to mitigate the unwanted effects of the AllowedHosts, SSL, and STS options when developing. Usually testing takes place using HTTP, not HTTPS, and on localhost, not your production domain. If you would like your development environment to mimic production with complete Host blocking, SSL redirects, and STS headers, leave this as false.
        /// </summary>
        public readonly bool IsDevelopment;
        /// <summary>
        /// PermissionsPolicy defines the Permissions-Policy header value. This allows sites to control browser features.
        /// </summary>
        public readonly string PermissionsPolicy;
        /// <summary>
        /// PublicKey is the public key that implements HPKP to prevent MITM attacks with forged certificates.
        /// </summary>
        public readonly string PublicKey;
        /// <summary>
        /// ReferrerPolicy defines the Referrer-Policy header value. This allows sites to control whether browsers forward the Referer header to other sites.
        /// </summary>
        public readonly string ReferrerPolicy;
        /// <summary>
        /// Deprecated: use RedirectRegex instead.
        /// </summary>
        public readonly bool SslForceHost;
        /// <summary>
        /// Deprecated: use RedirectRegex instead.
        /// </summary>
        public readonly string SslHost;
        /// <summary>
        /// SSLProxyHeaders defines the header keys with associated values that would indicate a valid HTTPS request. It can be useful when using other proxies (example: "X-Forwarded-Proto": "https").
        /// </summary>
        public readonly ImmutableDictionary<string, string> SslProxyHeaders;
        /// <summary>
        /// Deprecated: use EntryPoint redirection or RedirectScheme instead.
        /// </summary>
        public readonly bool SslRedirect;
        /// <summary>
        /// Deprecated: use EntryPoint redirection or RedirectScheme instead.
        /// </summary>
        public readonly bool SslTemporaryRedirect;
        /// <summary>
        /// STSIncludeSubdomains defines whether the includeSubDomains directive is appended to the Strict-Transport-Security header.
        /// </summary>
        public readonly bool StsIncludeSubdomains;
        /// <summary>
        /// STSPreload defines whether the preload flag is appended to the Strict-Transport-Security header.
        /// </summary>
        public readonly bool StsPreload;
        /// <summary>
        /// STSSeconds defines the max-age of the Strict-Transport-Security header. If set to 0, the header is not set.
        /// </summary>
        public readonly int StsSeconds;

        [OutputConstructor]
        private MiddlewareSpecHeaders(
            bool accessControlAllowCredentials,

            ImmutableArray<string> accessControlAllowHeaders,

            ImmutableArray<string> accessControlAllowMethods,

            ImmutableArray<string> accessControlAllowOriginList,

            ImmutableArray<string> accessControlAllowOriginListRegex,

            ImmutableArray<string> accessControlExposeHeaders,

            int accessControlMaxAge,

            bool addVaryHeader,

            ImmutableArray<string> allowedHosts,

            bool browserXssFilter,

            string contentSecurityPolicy,

            bool contentTypeNosniff,

            string customBrowserXSSValue,

            string customFrameOptionsValue,

            ImmutableDictionary<string, string> customRequestHeaders,

            ImmutableDictionary<string, string> customResponseHeaders,

            string featurePolicy,

            bool forceSTSHeader,

            bool frameDeny,

            ImmutableArray<string> hostsProxyHeaders,

            bool isDevelopment,

            string permissionsPolicy,

            string publicKey,

            string referrerPolicy,

            bool sslForceHost,

            string sslHost,

            ImmutableDictionary<string, string> sslProxyHeaders,

            bool sslRedirect,

            bool sslTemporaryRedirect,

            bool stsIncludeSubdomains,

            bool stsPreload,

            int stsSeconds)
        {
            AccessControlAllowCredentials = accessControlAllowCredentials;
            AccessControlAllowHeaders = accessControlAllowHeaders;
            AccessControlAllowMethods = accessControlAllowMethods;
            AccessControlAllowOriginList = accessControlAllowOriginList;
            AccessControlAllowOriginListRegex = accessControlAllowOriginListRegex;
            AccessControlExposeHeaders = accessControlExposeHeaders;
            AccessControlMaxAge = accessControlMaxAge;
            AddVaryHeader = addVaryHeader;
            AllowedHosts = allowedHosts;
            BrowserXssFilter = browserXssFilter;
            ContentSecurityPolicy = contentSecurityPolicy;
            ContentTypeNosniff = contentTypeNosniff;
            CustomBrowserXSSValue = customBrowserXSSValue;
            CustomFrameOptionsValue = customFrameOptionsValue;
            CustomRequestHeaders = customRequestHeaders;
            CustomResponseHeaders = customResponseHeaders;
            FeaturePolicy = featurePolicy;
            ForceSTSHeader = forceSTSHeader;
            FrameDeny = frameDeny;
            HostsProxyHeaders = hostsProxyHeaders;
            IsDevelopment = isDevelopment;
            PermissionsPolicy = permissionsPolicy;
            PublicKey = publicKey;
            ReferrerPolicy = referrerPolicy;
            SslForceHost = sslForceHost;
            SslHost = sslHost;
            SslProxyHeaders = sslProxyHeaders;
            SslRedirect = sslRedirect;
            SslTemporaryRedirect = sslTemporaryRedirect;
            StsIncludeSubdomains = stsIncludeSubdomains;
            StsPreload = stsPreload;
            StsSeconds = stsSeconds;
        }
    }
}
