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
    /// The required Secret field containing a Kubernetes ServiceAccount JWT used for authenticating with Vault. Use of 'ambient credentials' is not supported.
    /// </summary>
    public class IssuerSpecVaultAuthKubernetesSecretRefArgs : global::Pulumi.ResourceArgs
    {
        /// <summary>
        /// The key of the entry in the Secret resource's `data` field to be used. Some instances of this field may be defaulted, in others it may be required.
        /// </summary>
        [Input("key")]
        public Input<string>? Key { get; set; }

        /// <summary>
        /// Name of the resource being referred to. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
        /// </summary>
        [Input("name", required: true)]
        public Input<string> Name { get; set; } = null!;

        public IssuerSpecVaultAuthKubernetesSecretRefArgs()
        {
        }
        public static new IssuerSpecVaultAuthKubernetesSecretRefArgs Empty => new IssuerSpecVaultAuthKubernetesSecretRefArgs();
    }
}
