// *** WARNING: this file was generated by crd2pulumi. ***
// *** Do not edit by hand unless you're certain you know what you are doing! ***

using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Threading.Tasks;
using Pulumi.Serialization;

namespace Pulumi.Kubernetes.Types.Inputs.K8up.V1
{

    /// <summary>
    /// ResourceRequirementsTemplate describes the compute resource requirements (cpu, memory, etc.)
    /// </summary>
    public class ScheduleSpecResourceRequirementsTemplateArgs : global::Pulumi.ResourceArgs
    {
        [Input("limits")]
        private InputMap<Union<int, string>>? _limits;

        /// <summary>
        /// Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
        /// </summary>
        public InputMap<Union<int, string>> Limits
        {
            get => _limits ?? (_limits = new InputMap<Union<int, string>>());
            set => _limits = value;
        }

        [Input("requests")]
        private InputMap<Union<int, string>>? _requests;

        /// <summary>
        /// Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
        /// </summary>
        public InputMap<Union<int, string>> Requests
        {
            get => _requests ?? (_requests = new InputMap<Union<int, string>>());
            set => _requests = value;
        }

        public ScheduleSpecResourceRequirementsTemplateArgs()
        {
        }
        public static new ScheduleSpecResourceRequirementsTemplateArgs Empty => new ScheduleSpecResourceRequirementsTemplateArgs();
    }
}
