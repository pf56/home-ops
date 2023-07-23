using Pulumi;
using Pulumi.Crds.K8up.V1;
using Pulumi.Kubernetes.Types.Inputs.K8up.V1;
using Pulumi.Kubernetes.Types.Inputs.Meta.V1;

namespace Components;

public class DefaultBackupSchedule : ComponentResource
{
	public DefaultBackupSchedule(
		string name,
		DefaultBackupScheduleArgs args,
		ComponentResourceOptions? options = null
		) : base("homeops:Common:DefaultBackupSchedule", name, options)
	{
		Schedule backupSchedule = new($"{name}-backup-schedule", new ScheduleArgs
		{
			Metadata = new ObjectMetaArgs
			{
				Namespace = args.Namespace,
				Labels = args.Labels
			},
			Spec = new ScheduleSpecArgs
			{
				Backend = new ScheduleSpecBackendArgs
				{
					Rest = new ScheduleSpecBackendRestArgs
					{
						Url = args.RepoUrl
					},
					RepoPasswordSecretRef = new ScheduleSpecBackendRepoPasswordSecretRefArgs
					{
						Name = args.RepoCredentialsName,
						Key = args.RepoCredentialsKey
					}
				},
				Backup = new ScheduleSpecBackupArgs
				{
					Schedule = "0 3 * * *",
					FailedJobsHistoryLimit = 2,
					SuccessfulJobsHistoryLimit = 2
				},
				Check = new ScheduleSpecCheckArgs
				{
					Schedule = "0 1 * * 1",
					FailedJobsHistoryLimit = 2,
					SuccessfulJobsHistoryLimit = 2
				},
				Prune = new ScheduleSpecPruneArgs
				{
					Schedule = "0 1 * * 0",
					FailedJobsHistoryLimit = 2,
					SuccessfulJobsHistoryLimit = 2,
					Retention = new ScheduleSpecPruneRetentionArgs
					{
						KeepLast = 3,
						KeepDaily = 7,
						KeepWeekly = 4,
						KeepMonthly = 12
					}
				}
			}
		}, new CustomResourceOptions { Parent = this });
	}
}

public class DefaultBackupScheduleArgs : ResourceArgs
{
	public Input<string> Namespace { get; set; } = null!;
	public InputMap<string> Labels { get; set; } = new();
	public Input<string> RepoUrl { get; set; }
	public Output<string> RepoCredentialsName { get; set; }
	public string RepoCredentialsKey { get; set; }
}