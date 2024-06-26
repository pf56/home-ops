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
    /// TLSOptionSpec defines the desired state of a TLSOption.
    /// </summary>
    [OutputType]
    public sealed class TLSOptionSpec
    {
        /// <summary>
        /// ALPNProtocols defines the list of supported application level protocols for the TLS handshake, in order of preference. More info: https://doc.traefik.io/traefik/v2.10/https/tls/#alpn-protocols
        /// </summary>
        public readonly ImmutableArray<string> AlpnProtocols;
        /// <summary>
        /// CipherSuites defines the list of supported cipher suites for TLS versions up to TLS 1.2. More info: https://doc.traefik.io/traefik/v2.10/https/tls/#cipher-suites
        /// </summary>
        public readonly ImmutableArray<string> CipherSuites;
        /// <summary>
        /// ClientAuth defines the server's policy for TLS Client Authentication.
        /// </summary>
        public readonly Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSOptionSpecClientAuth ClientAuth;
        /// <summary>
        /// CurvePreferences defines the preferred elliptic curves in a specific order. More info: https://doc.traefik.io/traefik/v2.10/https/tls/#curve-preferences
        /// </summary>
        public readonly ImmutableArray<string> CurvePreferences;
        /// <summary>
        /// MaxVersion defines the maximum TLS version that Traefik will accept. Possible values: VersionTLS10, VersionTLS11, VersionTLS12, VersionTLS13. Default: None.
        /// </summary>
        public readonly string MaxVersion;
        /// <summary>
        /// MinVersion defines the minimum TLS version that Traefik will accept. Possible values: VersionTLS10, VersionTLS11, VersionTLS12, VersionTLS13. Default: VersionTLS10.
        /// </summary>
        public readonly string MinVersion;
        /// <summary>
        /// PreferServerCipherSuites defines whether the server chooses a cipher suite among his own instead of among the client's. It is enabled automatically when minVersion or maxVersion is set. Deprecated: https://github.com/golang/go/issues/45430
        /// </summary>
        public readonly bool PreferServerCipherSuites;
        /// <summary>
        /// SniStrict defines whether Traefik allows connections from clients connections that do not specify a server_name extension.
        /// </summary>
        public readonly bool SniStrict;

        [OutputConstructor]
        private TLSOptionSpec(
            ImmutableArray<string> alpnProtocols,

            ImmutableArray<string> cipherSuites,

            Pulumi.Kubernetes.Types.Outputs.Traefik.V1Alpha1.TLSOptionSpecClientAuth clientAuth,

            ImmutableArray<string> curvePreferences,

            string maxVersion,

            string minVersion,

            bool preferServerCipherSuites,

            bool sniStrict)
        {
            AlpnProtocols = alpnProtocols;
            CipherSuites = cipherSuites;
            ClientAuth = clientAuth;
            CurvePreferences = curvePreferences;
            MaxVersion = maxVersion;
            MinVersion = minVersion;
            PreferServerCipherSuites = preferServerCipherSuites;
            SniStrict = sniStrict;
        }
    }
}
