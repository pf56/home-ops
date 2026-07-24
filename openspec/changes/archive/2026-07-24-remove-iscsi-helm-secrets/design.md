## Context

The democratic-csi local chart deploys two subcharts: `node-man` for static NFS PersistentVolumes and `fn-iscsi` for dynamic FreeNAS iSCSI provisioning. Only `fn-iscsi` consumes `values.sops.yaml`, which forces Argo CD's repo-server to install and run helm-secrets with SOPS, age, vals, curl, and kubectl.

The live `fn-iscsi` driver has one consumer: Sabnzbd's `tmp-sabnzbd-0` 128Gi `ReadWriteOnce` claim, mounted at `/tmpdata`. It contains only disposable scratch data. Sabnzbd's configuration is independently stored on the Longhorn-backed `data-sabnzbd-0` claim, and completed downloads remain on the retained `node-man` NFS volume.

## Goals / Non-Goals

**Goals:**
- Replace Sabnzbd's disposable scratch storage with a newly provisioned 128Gi Longhorn PVC.
- Deprovision the old FreeNAS iSCSI volume while its CSI controller remains available.
- Remove all `fn-iscsi` and Helm-secrets configuration without affecting the active `node-man` CSI driver.
- Remove the Argo CD-specific SOPS/age decryption path after its only encrypted values file is gone.

**Non-Goals:**
- Preserve or copy contents from `tmp-sabnzbd-0`.
- Migrate the FreeNAS iSCSI configuration or credentials to Infisical.
- Alter the Sabnzbd configuration PVC, completed-downloads NFS volume, Longhorn installation, or static `node-man` volumes.
- Remove SOPS/age support used outside Argo CD Helm values.

## Decisions

### Recreate the existing scratch claim as Longhorn-backed storage

Change the `tmp` StatefulSet volume-claim template from `freenas-api-iscsi-csi` to `longhorn`, preserving its 128Gi size and `ReadWriteOnce` access mode. Kubernetes will dynamically provision a replacement Longhorn PV when the old `tmp-sabnzbd-0` PVC has been deleted and the StatefulSet is recreated.

Changing the existing PVC in place is not possible: both a bound PVC's storage class and a StatefulSet's `volumeClaimTemplates` are immutable. Introducing a differently named standalone PVC was considered, but preserving the template and claim name is the smaller configuration change when the old scratch data is intentionally discarded.

### Decommission the old iSCSI volume before removing its controller

Delete the old `tmp-sabnzbd-0` PVC, rather than deleting its PV directly, after stopping the StatefulSet. Its reclaim policy is `Delete`, so the active `fn-iscsi` controller deletes the corresponding FreeNAS volume and PV. Recreate the StatefulSet only after the old claim and PV are gone.

Deleting the PV alone was rejected because its bound PVC would remain and cannot request a replacement Longhorn volume. Removing `fn-iscsi` first was rejected because it risks leaving the FreeNAS volume orphaned.

### Retain only the static NFS democratic-csi subchart

Remove the `fn-iscsi` dependency, its `values.sops.yaml` file, and the `secrets://` value-file reference. Retain `node-man`, which still serves seven bound static NFS PersistentVolumes used by Jellyfin, Radarr, Sabnzbd, and Sonarr.

Removing the full democratic-csi chart was rejected because it would interrupt those active NFS volumes.

### Remove the complete Argo CD Helm-secrets customization

Once no Argo CD application uses encrypted Helm values, remove the repo-server's custom Helm wrapper, helper-tool init container, environment variables, EmptyDir and age-key volumes, and `helm.valuesFileSchemes` configuration. Remove the bootstrap command that creates `helm-secrets-private-keys` and delete the dedicated `argocd` SOPS recipient and `values.sops.yaml` creation rule.

Retaining any portion of this integration was rejected because repository search identifies no remaining consumer and would preserve an unnecessary private key and supply-chain download path in the repo-server.

## Risks / Trade-offs

- [The scratch claim is deleted before Sabnzbd stops] -> Stop and delete the StatefulSet before deleting `tmp-sabnzbd-0`; confirm its data claim remains bound.
- [Argo CD recreates the old StatefulSet before the scratch PVC is deleted] -> Perform the destructive operation while automated sync is disabled or the application is otherwise held from reconciliation, then sync only after the claim and PV have been removed.
- [The FreeNAS volume is orphaned] -> Delete the PVC while `dcsi-fn-iscsi` is still healthy, then confirm the corresponding PV and backend volume are absent before removing the driver.
- [The replacement claim binds to the old PV] -> Verify `tmp-sabnzbd-0` and its iSCSI PV are absent before recreating the StatefulSet; verify the replacement PVC reports storage class `longhorn`.
- [Static NFS workloads regress] -> Render the retained `node-man` dependency and verify all existing `org.democratic-csi.node-manual` PVs remain bound after reconciliation.

## Migration Plan

1. Commit the Sabnzbd template change to request Longhorn for `tmp`, without reconciling the immutable StatefulSet update.
2. Stop and delete the Sabnzbd StatefulSet while retaining `data-sabnzbd-0` and `tmp-sabnzbd-0`.
3. Delete `tmp-sabnzbd-0`; wait for its FreeNAS iSCSI PV and backend volume to be deleted by the healthy `fn-iscsi` controller.
4. Reconcile Sabnzbd to recreate the StatefulSet and provision a new Longhorn-backed `tmp-sabnzbd-0`; verify the running pod mounts it at `/tmpdata`.
5. Remove `fn-iscsi`, encrypted Helm values, Helm-secrets, and the dedicated SOPS recipient/configuration; reconcile Argo CD.
6. Verify no FreeNAS iSCSI CSI driver, StorageClass, Helm-secrets references, or age-key bootstrap Secret remain, while `node-man` PVs remain bound.

Rollback before step 3 consists of restoring the iSCSI storage-class template and recreating the StatefulSet against the retained claim. After step 3, restoring the prior configuration would provision a new, empty iSCSI volume; discarded scratch data cannot be recovered.

## Open Questions

- None. The only iSCSI claim is confirmed mounted by a running Sabnzbd pod, and its contents are approved for deletion.
