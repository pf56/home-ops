## 1. Prepare the Sabnzbd Storage Cutover

- [x] 1.1 Change the Sabnzbd `tmp` volume-claim template to request a 128Gi `ReadWriteOnce` Longhorn volume while preserving the `/tmpdata` mount and the existing config and downloads volumes.
- [x] 1.2 Render the updated Sabnzbd chart and confirm the StatefulSet's immutable volume-claim-template change is the only required workload replacement.

## 2. Replace the Disposable Scratch Volume

- [x] 2.1 Hold Sabnzbd from Argo CD reconciliation, stop and delete its StatefulSet, and verify `data-sabnzbd-0` remains bound.
- [x] 2.2 Delete the disposable `tmp-sabnzbd-0` PVC while the `dcsi-fn-iscsi` controller is healthy; verify its FreeNAS iSCSI PV and backend volume are deleted.
- [x] 2.3 Reconcile Sabnzbd, then verify the recreated `tmp-sabnzbd-0` PVC is 128Gi, bound through the `longhorn` StorageClass, mounted at `/tmpdata`, and used by a healthy Sabnzbd pod.

## 3. Remove iSCSI and Helm-Secrets Configuration

- [x] 3.1 Remove the `fn-iscsi` democratic-csi dependency, its encrypted values file, and the Helm-secrets value-file source; regenerate the dependency lock while retaining `node-man`.
- [x] 3.2 Remove the Argo CD repo-server Helm-secrets helper tooling, custom Helm wrapper, age-key mount, secret value-file schemes, and bootstrap key creation.
- [x] 3.3 Remove the dedicated Argo CD age recipient and Kubernetes `values.sops.yaml` creation rule from `.sops.yaml`.

## 4. Validate the Cleanup

- [x] 4.1 Render the affected Helm/Kustomize configuration and verify repository searches contain no Helm-secrets, FreeNAS iSCSI, `fn-iscsi`, or Kubernetes Helm `values.sops.yaml` references.
- [x] 4.2 After Argo CD reconciliation, verify the FreeNAS iSCSI driver, controller/node pods, StorageClass, and `helm-secrets-private-keys` Secret are absent.
- [x] 4.3 Verify all existing `org.democratic-csi.node-manual` PersistentVolumes remain bound and the retained democratic-csi node-man controller and node pods are healthy.
