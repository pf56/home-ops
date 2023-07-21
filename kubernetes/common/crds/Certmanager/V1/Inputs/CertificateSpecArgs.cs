// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.Certmanager.V1
{

    /// <summary>
    /// Desired state of the Certificate resource.
    /// </summary>
    public class CertificateSpecArgs : global::Pulumi.ResourceArgs
    {
        [Input("additionalOutputFormats")]
        private InputList<Pulumi.Kubernetes.Types.Inputs.Certmanager.V1.CertificateSpecAdditionalOutputFormatsArgs>? _additionalOutputFormats;

        /// <summary>
        /// AdditionalOutputFormats defines extra output formats of the private key and signed certificate chain to be written to this Certificate's target Secret. This is an Alpha Feature and is only enabled with the `--feature-gates=AdditionalCertificateOutputFormats=true` option on both the controller and webhook components.
        /// </summary>
        public InputList<Pulumi.Kubernetes.Types.Inputs.Certmanager.V1.CertificateSpecAdditionalOutputFormatsArgs> AdditionalOutputFormats
        {
            get => _additionalOutputFormats ?? (_additionalOutputFormats = new InputList<Pulumi.Kubernetes.Types.Inputs.Certmanager.V1.CertificateSpecAdditionalOutputFormatsArgs>());
            set => _additionalOutputFormats = value;
        }

        /// <summary>
        /// CommonName is a common name to be used on the Certificate. The CommonName should have a length of 64 characters or fewer to avoid generating invalid CSRs. This value is ignored by TLS clients when any subject alt name is set. This is x509 behaviour: https://tools.ietf.org/html/rfc6125#section-6.4.4
        /// </summary>
        [Input("commonName")]
        public Input<string>? CommonName { get; set; }

        [Input("dnsNames")]
        private InputList<string>? _dnsNames;

        /// <summary>
        /// DNSNames is a list of DNS subjectAltNames to be set on the Certificate.
        /// </summary>
        public InputList<string> DnsNames
        {
            get => _dnsNames ?? (_dnsNames = new InputList<string>());
            set => _dnsNames = value;
        }

        /// <summary>
        /// The requested 'duration' (i.e. lifetime) of the Certificate. This option may be ignored/overridden by some issuer types. If unset this defaults to 90 days. Certificate will be renewed either 2/3 through its duration or `renewBefore` period before its expiry, whichever is later. Minimum accepted duration is 1 hour. Value must be in units accepted by Go time.ParseDuration https://golang.org/pkg/time/#ParseDuration
        /// </summary>
        [Input("duration")]
        public Input<string>? Duration { get; set; }

        [Input("emailAddresses")]
        private InputList<string>? _emailAddresses;

        /// <summary>
        /// EmailAddresses is a list of email subjectAltNames to be set on the Certificate.
        /// </summary>
        public InputList<string> EmailAddresses
        {
            get => _emailAddresses ?? (_emailAddresses = new InputList<string>());
            set => _emailAddresses = value;
        }

        /// <summary>
        /// EncodeUsagesInRequest controls whether key usages should be present in the CertificateRequest
        /// </summary>
        [Input("encodeUsagesInRequest")]
        public Input<bool>? EncodeUsagesInRequest { get; set; }

        [Input("ipAddresses")]
        private InputList<string>? _ipAddresses;

        /// <summary>
        /// IPAddresses is a list of IP address subjectAltNames to be set on the Certificate.
        /// </summary>
        public InputList<string> IpAddresses
        {
            get => _ipAddresses ?? (_ipAddresses = new InputList<string>());
            set => _ipAddresses = value;
        }

        /// <summary>
        /// IsCA will mark this Certificate as valid for certificate signing. This will automatically add the `cert sign` usage to the list of `usages`.
        /// </summary>
        [Input("isCA")]
        public Input<bool>? IsCA { get; set; }

        /// <summary>
        /// IssuerRef is a reference to the issuer for this certificate. If the `kind` field is not set, or set to `Issuer`, an Issuer resource with the given name in the same namespace as the Certificate will be used. If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the provided name will be used. The `name` field in this stanza is required at all times.
        /// </summary>
        [Input("issuerRef", required: true)]
        public Input<Pulumi.Kubernetes.Types.Inputs.Certmanager.V1.CertificateSpecIssuerRefArgs> IssuerRef { get; set; } = null!;

        /// <summary>
        /// Keystores configures additional keystore output formats stored in the `secretName` Secret resource.
        /// </summary>
        [Input("keystores")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Certmanager.V1.CertificateSpecKeystoresArgs>? Keystores { get; set; }

        /// <summary>
        /// LiteralSubject is an LDAP formatted string that represents the [X.509 Subject field](https://datatracker.ietf.org/doc/html/rfc5280#section-4.1.2.6). Use this *instead* of the Subject field if you need to ensure the correct ordering of the RDN sequence, such as when issuing certs for LDAP authentication. See https://github.com/cert-manager/cert-manager/issues/3203, https://github.com/cert-manager/cert-manager/issues/4424. This field is alpha level and is only supported by cert-manager installations where LiteralCertificateSubject feature gate is enabled on both cert-manager controller and webhook.
        /// </summary>
        [Input("literalSubject")]
        public Input<string>? LiteralSubject { get; set; }

        /// <summary>
        /// Options to control private keys used for the Certificate.
        /// </summary>
        [Input("privateKey")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Certmanager.V1.CertificateSpecPrivateKeyArgs>? PrivateKey { get; set; }

        /// <summary>
        /// How long before the currently issued certificate's expiry cert-manager should renew the certificate. The default is 2/3 of the issued certificate's duration. Minimum accepted value is 5 minutes. Value must be in units accepted by Go time.ParseDuration https://golang.org/pkg/time/#ParseDuration
        /// </summary>
        [Input("renewBefore")]
        public Input<string>? RenewBefore { get; set; }

        /// <summary>
        /// revisionHistoryLimit is the maximum number of CertificateRequest revisions that are maintained in the Certificate's history. Each revision represents a single `CertificateRequest` created by this Certificate, either when it was created, renewed, or Spec was changed. Revisions will be removed by oldest first if the number of revisions exceeds this number. If set, revisionHistoryLimit must be a value of `1` or greater. If unset (`nil`), revisions will not be garbage collected. Default value is `nil`.
        /// </summary>
        [Input("revisionHistoryLimit")]
        public Input<int>? RevisionHistoryLimit { get; set; }

        /// <summary>
        /// SecretName is the name of the secret resource that will be automatically created and managed by this Certificate resource. It will be populated with a private key and certificate, signed by the denoted issuer.
        /// </summary>
        [Input("secretName", required: true)]
        public Input<string> SecretName { get; set; } = null!;

        /// <summary>
        /// SecretTemplate defines annotations and labels to be copied to the Certificate's Secret. Labels and annotations on the Secret will be changed as they appear on the SecretTemplate when added or removed. SecretTemplate annotations are added in conjunction with, and cannot overwrite, the base set of annotations cert-manager sets on the Certificate's Secret.
        /// </summary>
        [Input("secretTemplate")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Certmanager.V1.CertificateSpecSecretTemplateArgs>? SecretTemplate { get; set; }

        /// <summary>
        /// Full X509 name specification (https://golang.org/pkg/crypto/x509/pkix/#Name).
        /// </summary>
        [Input("subject")]
        public Input<Pulumi.Kubernetes.Types.Inputs.Certmanager.V1.CertificateSpecSubjectArgs>? Subject { get; set; }

        [Input("uris")]
        private InputList<string>? _uris;

        /// <summary>
        /// URIs is a list of URI subjectAltNames to be set on the Certificate.
        /// </summary>
        public InputList<string> Uris
        {
            get => _uris ?? (_uris = new InputList<string>());
            set => _uris = value;
        }

        [Input("usages")]
        private InputList<string>? _usages;

        /// <summary>
        /// Usages is the set of x509 usages that are requested for the certificate. Defaults to `digital signature` and `key encipherment` if not specified.
        /// </summary>
        public InputList<string> Usages
        {
            get => _usages ?? (_usages = new InputList<string>());
            set => _usages = value;
        }

        public CertificateSpecArgs()
        {
        }
        public static new CertificateSpecArgs Empty => new CertificateSpecArgs();
    }
}
