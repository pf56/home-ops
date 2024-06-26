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
    /// Issuer defines the client certificate issuer details to add to the X-Forwarded-Tls-Client-Cert-Info header.
    /// </summary>
    [OutputType]
    public sealed class MiddlewareSpecPassTLSClientCertInfoIssuer
    {
        /// <summary>
        /// CommonName defines whether to add the organizationalUnit information into the issuer.
        /// </summary>
        public readonly bool CommonName;
        /// <summary>
        /// Country defines whether to add the country information into the issuer.
        /// </summary>
        public readonly bool Country;
        /// <summary>
        /// DomainComponent defines whether to add the domainComponent information into the issuer.
        /// </summary>
        public readonly bool DomainComponent;
        /// <summary>
        /// Locality defines whether to add the locality information into the issuer.
        /// </summary>
        public readonly bool Locality;
        /// <summary>
        /// Organization defines whether to add the organization information into the issuer.
        /// </summary>
        public readonly bool Organization;
        /// <summary>
        /// Province defines whether to add the province information into the issuer.
        /// </summary>
        public readonly bool Province;
        /// <summary>
        /// SerialNumber defines whether to add the serialNumber information into the issuer.
        /// </summary>
        public readonly bool SerialNumber;

        [OutputConstructor]
        private MiddlewareSpecPassTLSClientCertInfoIssuer(
            bool commonName,

            bool country,

            bool domainComponent,

            bool locality,

            bool organization,

            bool province,

            bool serialNumber)
        {
            CommonName = commonName;
            Country = country;
            DomainComponent = domainComponent;
            Locality = locality;
            Organization = organization;
            Province = province;
            SerialNumber = serialNumber;
        }
    }
}
