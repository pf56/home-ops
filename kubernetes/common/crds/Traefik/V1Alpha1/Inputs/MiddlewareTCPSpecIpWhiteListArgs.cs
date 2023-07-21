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
    /// IPWhiteList defines the IPWhiteList middleware configuration.
    /// </summary>
    public class MiddlewareTCPSpecIpWhiteListArgs : global::Pulumi.ResourceArgs
    {
        [Input("sourceRange")]
        private InputList<string>? _sourceRange;

        /// <summary>
        /// SourceRange defines the allowed IPs (or ranges of allowed IPs by using CIDR notation).
        /// </summary>
        public InputList<string> SourceRange
        {
            get => _sourceRange ?? (_sourceRange = new InputList<string>());
            set => _sourceRange = value;
        }

        public MiddlewareTCPSpecIpWhiteListArgs()
        {
        }
        public static new MiddlewareTCPSpecIpWhiteListArgs Empty => new MiddlewareTCPSpecIpWhiteListArgs();
    }
}